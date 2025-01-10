import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLocationView = false
    @State private var showDateView = false
    @State private var navigateToEventListView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    HStack {
                        Image("Logo") // Logo from assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 60)

                        Spacer()

                        Button(action: {
                            // Notification action (if needed)
                        }) {
                            ZStack {
                                Image(systemName: "bell.fill")
                                    .font(.title2)
                                    .foregroundColor(Constants.Design.primaryColor)
                                if viewModel.notificationsCount > 0 {
                                    Text("\(viewModel.notificationsCount)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Search Section
                    VStack(spacing: 8) {
                        Button(action: {
                            showLocationView = true
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Constants.Design.secondaryColor)

                                Text(viewModel.selectedLocation)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(Constants.Design.primaryColor)

                                Spacer()
                            }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        }
                        .sheet(isPresented: $showLocationView) {
                            LocationView { selectedLocation in
                                viewModel.selectedLocation = selectedLocation
                            }
                        }

                        Button(action: {
                            showDateView = true
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Constants.Design.secondaryColor)

                                Text(viewModel.selectedDate.isEmpty ? "Select date" : viewModel.selectedDate)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(Constants.Design.primaryColor)

                                Spacer()
                            }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        }
                        .sheet(isPresented: $showDateView) {
                            DateView { selectedDate in
                                viewModel.selectedDate = selectedDate
                            }
                        }

                        NavigationLink(
                            destination: EventListView(
                                selectedLocation: viewModel.selectedLocation,
                                selectedDate: viewModel.selectedDate
                            ),
                            isActive: $navigateToEventListView
                        ) {
                            EmptyView()
                        }

                        Button(action: {
                            navigateToEventListView = true
                        }) {
                            Text("Search")
                                .font(.custom("Poppins-SemiBold", size: 24))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Constants.Design.secondaryColor)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)

                    // Explore Cities Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore Cities")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.primaryColor)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.cities, id: \.self) { city in
                                    ZStack(alignment: .bottomLeading) {
                                        Image(city.description) // Placeholder image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                LinearGradient(
                                                    colors: [Color.black.opacity(0.6), Color.clear],
                                                    startPoint: .bottom,
                                                    endPoint: .center
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            )

                                        Text(city.description) // Use `description` for the city name
                                            .font(.custom("Poppins-SemiBold", size: 14))
                                            .foregroundColor(.white)
                                            .padding([.leading, .bottom], 8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Explore Categories Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore Categories")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.primaryColor)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    ZStack(alignment: .bottomLeading) {
                                        Image(category.description) // Placeholder image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(
                                                LinearGradient(
                                                    colors: [Color.black.opacity(0.6), Color.clear],
                                                    startPoint: .bottom,
                                                    endPoint: .center
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            )

                                        Text(category.description)
                                            .font(.custom("Poppins-SemiBold", size: 14))
                                            .foregroundColor(.white)
                                            .padding([.leading, .bottom], 8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Reset Onboarding Button
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
                    }) {
                        Text("Reset Onboarding")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.white))
        }
    }
}
