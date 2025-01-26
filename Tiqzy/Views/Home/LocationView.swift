import SwiftUI

/// A view that allows the user to select a location.
/// Options include entering a destination, selecting the current location, or choosing from a list of cities.
struct LocationView: View {
    var onLocationSelected: (String) -> Void // Closure to send the selected location.
    @Environment(\.dismiss) var dismiss // Environment to handle view dismissal.
    @StateObject private var viewModel = LocationViewModel() // ViewModel to handle logic and data.

    var body: some View {
        VStack(spacing: 16) {
            // Header Section: Back Button and Search Bar
            HStack(spacing: 12) {
                // Back Button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Constants.Design.primaryColor)
                }

                // Search Bar
                TextField("Enter Destination", text: $viewModel.searchQuery)
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal)

            // Main Content
            Group {
                if viewModel.isSearchQueryEmpty {
                    // Display default options when no search query is entered.
                    VStack(spacing: 12) {
                        // Option: "Anywhere in Holland"
                        Button(action: {
                            onLocationSelected("Anywhere")
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                // Icon for "Anywhere"
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Constants.Design.secondaryColor.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "globe")
                                            .font(.title2)
                                            .foregroundColor(Constants.Design.secondaryColor)
                                    )

                                // Label
                                Text("Anywhere in Holland")
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .foregroundColor(Constants.Design.secondaryColor)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }

                        // Option: "Current Location"
                        Button(action: {
                            onLocationSelected(viewModel.currentLocation)
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                // Icon for "Current Location"
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Constants.Design.secondaryColor.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "mappin")
                                            .font(.title2)
                                            .foregroundColor(Constants.Design.secondaryColor)
                                    )

                                // Labels for "Current Location"
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Current location")
                                        .font(.custom("Poppins-Medium", size: 16))
                                        .foregroundColor(.black)
                                    Text(viewModel.currentLocation)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    // Display filtered list of cities based on the search query.
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.filteredCities, id: \.self) { city in
                                Button(action: {
                                    onLocationSelected(city.description)
                                    dismiss()
                                }) {
                                    HStack(spacing: 12) {
                                        // Icon for a city
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Constants.Design.secondaryColor.opacity(0.1))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Image(systemName: "mappin")
                                                    .font(.title2)
                                                    .foregroundColor(Constants.Design.secondaryColor)
                                            )

                                        // Labels for the city
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(city.description)
                                                .font(.custom("Poppins-Medium", size: 16))
                                                .foregroundColor(.black)
                                            Text(city.region)
                                                .font(.custom("Poppins-Regular", size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.isSearchQueryEmpty)

            Spacer()
        }
        .padding(.top, 20)
        .onAppear {
            viewModel.fetchCurrentLocation() // Fetch the user's current location on appear.
        }
    }
}
