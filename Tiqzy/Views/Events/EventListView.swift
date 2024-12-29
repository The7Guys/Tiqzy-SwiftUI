import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()

    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    Button(action: {
                        // Back action (handle navigation logic)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(Constants.Design.primaryColor)
                    }

                    Spacer()

                    HStack {
                        Text("Amsterdam")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(Constants.Design.primaryColor)
                        
                        Spacer()

                        Text("15 Oct - 19 Oct")
                            .font(.custom("Poppins-SemiBold", size: 20)) // Same font and size as "Amsterdam"
                            .foregroundColor(Constants.Design.primaryColor)
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
    EventListView()
}
