import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    
    @State private var showLocationView = false
    @State private var showDateView = false
    
    @State var selectedLocation: String
    @State var selectedDate: String

    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    
                    HStack {
                        Button(action: {
                            showLocationView = true
                        }) {
                            Text(selectedLocation)
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                        .sheet(isPresented: $showLocationView) {
                            LocationView { newLocation in
                                selectedLocation = newLocation
                            }
                        }

                        Spacer()

                        Button(action: {
                            showDateView = true
                        }) {
                            Text(selectedDate)
                                .font(.custom("Poppins-SemiBold", size: 20))
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                        .sheet(isPresented: $showDateView) {
                            DateView { newDate in
                                selectedDate = newDate
                            }
                        }
                    }

                    Spacer()
                }
                .padding()

                // Sort & Filter Section
                HStack {
                    Button(action: {
                        // Sort action
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

                    Spacer()

                    Button(action: {
                        // Filter action
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
                ScrollView {
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
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

#Preview {
    EventListView(selectedLocation: "Amsterdam", selectedDate: "15 Oct - 19 Oct")
}
