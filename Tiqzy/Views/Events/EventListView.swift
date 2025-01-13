import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel: EventListViewModel

    @State private var showLocationView = false
    @State private var showDateView = false
    @State private var showSortOptions = false

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
                    // Header Section
                    HStack {
                        Button(action: {
                            showLocationView = true
                        }) {
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

                        Button(action: {
                            showDateView = true
                        }) {
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

                    // Sort & Filter Section
                    HStack {
                        Button(action: {
                            showSortOptions = true
                        }) {
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

                        Button(action: {
                            // Filter action (optional future implementation)
                        }) {
                            HStack {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                Text("Filter")
                                    .font(.custom("Poppins-Regular", size: 16))
                            }
                            .foregroundColor(Constants.Design.primaryColor)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)

                    // Event Count
                    Text("\(viewModel.events.count) Activities")
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(Constants.Design.primaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Event List
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.events) { event in
                            NavigationLink(destination: EventDetailView(eventID: event.id)) {
                                EventCard(event: event)
                            }
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 16) // Additional bottom padding
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                viewModel.fetchEvents()
            }
        }
    }
}
