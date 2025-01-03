import SwiftUI

struct LocationView: View {
    var onLocationSelected: (String) -> Void // Closure to send the selected location
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LocationViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // Header Section with Back Button and Search Bar
            HStack(spacing: 12) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Constants.Design.primaryColor)
                }

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
                    // Options: Anywhere in Holland and Current Location
                    VStack(spacing: 12) {
                        Button(action: {
                            onLocationSelected("Anywhere")
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Constants.Design.secondaryColor.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "globe")
                                            .font(.title2)
                                            .foregroundColor(Constants.Design.secondaryColor)
                                    )

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Anywhere in Holland")
                                        .font(.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(Constants.Design.secondaryColor)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal) // Ensures consistent alignment with city list
                        }

                        Button(action: {
                            onLocationSelected(viewModel.currentLocation)
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Constants.Design.secondaryColor.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "mappin")
                                            .font(.title2)
                                            .foregroundColor(Constants.Design.secondaryColor)
                                    )

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
                            .padding(.horizontal) // Ensures consistent alignment with city list
                        }
                    }
                } else {
                    // Filtered Cities
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.filteredCities, id: \.self) { city in
                                Button(action: {
                                    onLocationSelected(city.description)
                                    dismiss()
                                }) {
                                    HStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Constants.Design.secondaryColor.opacity(0.1))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Image(systemName: "mappin")
                                                    .font(.title2)
                                                    .foregroundColor(Constants.Design.secondaryColor)
                                            )

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
            viewModel.fetchCurrentLocation()
        }
    }
}
