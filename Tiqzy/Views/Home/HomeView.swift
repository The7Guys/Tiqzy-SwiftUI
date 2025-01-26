import SwiftUI

/// The main view of the app's home screen, allowing users to search for events, explore cities, and categories.
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // ViewModel to manage the home screen's data and state.
    @State private var showLocationView = false // Tracks whether the location selection view is displayed.
    @State private var showDateView = false // Tracks whether the date selection view is displayed.
    @State private var navigateToEventListView = false // Tracks whether to navigate to the EventListView.

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header Section
                    HStack {
                        Image("Logo") // App logo from assets.
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 60)

                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Search Section
                    VStack(spacing: 8) {
                        // Location Selection Button
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5))
                            )
                        }
                        .sheet(isPresented: $showLocationView) {
                            LocationView { selectedLocation in
                                viewModel.selectedLocation = selectedLocation
                            }
                        }

                        // Date Selection Button
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5))
                            )
                        }
                        .sheet(isPresented: $showDateView) {
                            DateView { selectedDate in
                                viewModel.selectedDate = selectedDate
                            }
                        }

                        // Hidden NavigationLink to EventListView
                        NavigationLink(
                            destination: EventListView(
                                selectedLocation: viewModel.selectedLocation,
                                selectedDate: viewModel.selectedDate
                            ),
                            isActive: $navigateToEventListView
                        ) {
                            EmptyView()
                        }

                        // Search Button
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

                    // MARK: - Explore Cities Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore Cities")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.primaryColor)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.cities, id: \.self) { city in
                                    NavigationLink(
                                        destination: EventListView(
                                            selectedLocation: city.description, // Pass city to EventListView.
                                            selectedDate: "Anytime" // Use default date filter.
                                        )
                                    ) {
                                        ZStack(alignment: .bottomLeading) {
                                            Image(city.description) // Placeholder image for city.
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

                                            Text(city.description) // City name overlay.
                                                .font(.custom("Poppins-SemiBold", size: 14))
                                                .foregroundColor(.white)
                                                .padding([.leading, .bottom], 8)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: - Explore Categories Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore Categories")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(Constants.Design.primaryColor)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    NavigationLink(
                                        destination: EventListView(
                                            selectedLocation: "Anywhere",
                                            selectedDate: "Anytime",
                                            selectedCategories: [category] // Pass category to EventListView.
                                        )
                                    ) {
                                        ZStack(alignment: .bottomLeading) {
                                            Image(category.description) // Placeholder for category.
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

                                            Text(category.description) // Category name overlay.
                                                .font(.custom("Poppins-SemiBold", size: 14))
                                                .foregroundColor(.white)
                                                .padding([.leading, .bottom], 8)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.white))
        }
    }
}
