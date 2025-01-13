import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel: EventListViewModel

    @State private var showLocationView = false
    @State private var showDateView = false
    @State private var showSortOptions = false
    @State private var showFilterView = false // State for FilterView

    init(selectedLocation: String, selectedDate: String) {
        _viewModel = StateObject(wrappedValue: EventListViewModel(selectedLocation: selectedLocation, selectedDate: selectedDate))
    }

    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    sortAndFilterSection
                    eventCountSection
                    eventGridSection
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                viewModel.fetchEvents()
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: { showLocationView = true }) {
                Text(viewModel.selectedLocation)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .sheet(isPresented: $showLocationView) {
                LocationView { newLocation in
                    viewModel.updateLocation(newLocation)
                }
            }

            Spacer()

            Button(action: { showDateView = true }) {
                Text(viewModel.selectedDate)
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .sheet(isPresented: $showDateView) {
                DateView { newDate in
                    viewModel.updateDate(newDate)
                }
            }
        }
        .padding()
    }

    // MARK: - Sort & Filter Section
    private var sortAndFilterSection: some View {
        HStack {
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
                    viewModel.fetchEvents()
                }
            }

            Spacer()

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
                    categories: Category.allCases,
                    applyFilterAction: viewModel.updateCategories // Pass the update function
                )
            }
        }
        .padding(.horizontal)
    }
    // MARK: - Event Count Section
    private var eventCountSection: some View {
        Text("\(viewModel.events.count) Activities")
            .font(.custom("Poppins-SemiBold", size: 16))
            .foregroundColor(Constants.Design.primaryColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }

    // MARK: - Event Grid Section
    private var eventGridSection: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.events) { event in
                NavigationLink(destination: EventDetailView(eventID: event.id)) {
                    EventCard(event: event)
                }
            }
        }
        .padding()
    }
}
