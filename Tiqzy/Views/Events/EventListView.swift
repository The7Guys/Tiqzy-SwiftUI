import SwiftUI

/// A view that displays a list of events, allowing users to filter, sort, and search by location and date.
struct EventListView: View {
    @StateObject private var viewModel: EventListViewModel // The ViewModel that manages events and user selections.

    @State private var showLocationView = false // Controls the display of the location selection view.
    @State private var showDateView = false // Controls the display of the date selection view.
    @State private var showSortOptions = false // Controls the display of the sort options view.
    @State private var showFilterView = false // Controls the display of the filter view.

    /// Initializes the view with the selected location, date, and optional categories.
    /// - Parameters:
    ///   - selectedLocation: The initial location for filtering events.
    ///   - selectedDate: The initial date for filtering events.
    ///   - selectedCategories: The categories to filter events (optional).
    init(selectedLocation: String, selectedDate: String, selectedCategories: Set<Category> = []) {
        let viewModel = EventListViewModel(
            selectedLocation: selectedLocation,
            selectedDate: selectedDate
        )
        viewModel.updateCategories(selectedCategories) // Apply the selected categories to the ViewModel.
        _viewModel = StateObject(wrappedValue: viewModel) // Assign the initialized ViewModel.
    }

    /// Grid layout configuration for displaying events.
    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection // Header with location and date selectors.
                    sortAndFilterSection // Buttons for sorting and filtering.
                    eventCountSection // Displays the count of events.
                    eventGridSection // Displays the list of events in a grid.
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                // Fetch events when the view appears if not already fetched.
                if viewModel.events.isEmpty {
                    viewModel.fetchEvents()
                }
            }
        }
    }

    // MARK: - Header Section
    /// The header section includes buttons for selecting location and date.
    private var headerSection: some View {
        HStack {
            // Location Selector
            Button(action: { showLocationView = true }) {
                Text(viewModel.selectedLocation)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .sheet(isPresented: $showLocationView) {
                LocationView { newLocation in
                    viewModel.updateLocation(newLocation) // Update location in the ViewModel.
                }
            }

            Spacer()

            // Date Selector
            Button(action: { showDateView = true }) {
                Text(viewModel.selectedDate)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .sheet(isPresented: $showDateView) {
                DateView { newDate in
                    viewModel.updateDate(newDate) // Update date in the ViewModel.
                }
            }
        }
        .padding()
    }

    // MARK: - Sort & Filter Section
    /// The section containing sort and filter buttons.
    private var sortAndFilterSection: some View {
        HStack {
            // Sort Button
            Button(action: { showSortOptions = true }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort")
                        .font(.custom("Poppins-Regular", size: 16))
                }
                .foregroundColor(Constants.Design.primaryColor)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .sheet(isPresented: $showSortOptions) {
                SortOptionsView(selectedOption: $viewModel.sortOption) {
                    viewModel.fetchEvents() // Refetch events when sort option changes.
                }
            }

            Spacer()

            // Filter Button
            Button(action: { showFilterView = true }) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filter")
                        .font(.custom("Poppins-Regular", size: 16))
                }
                .foregroundColor(Constants.Design.primaryColor)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .sheet(isPresented: $showFilterView) {
                FilterView(
                    selectedCategories: $viewModel.selectedCategories,
                    categories: Category.allCases
                ) { _ in
                    viewModel.fetchEvents() // Refetch events after filters are applied.
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Event Count Section
    /// Displays the total count of events.
    private var eventCountSection: some View {
        Text("\(viewModel.events.count) Activities")
            .font(.custom("Poppins-SemiBold", size: 16))
            .foregroundColor(Constants.Design.primaryColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }

    // MARK: - Event Grid Section
    /// Displays events in a grid layout.
    private var eventGridSection: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.events) { event in
                NavigationLink(destination: EventDetailView(eventID: event.id)) {
                    EventCard(event: event) // Event card for each event.
                }
            }
        }
        .padding()
    }
}
