import SwiftUI

struct LocationView: View {
    var onLocationSelected: (String) -> Void // Closure to send the selected location
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LocationViewModel()

    var body: some View {
        VStack(spacing: 20) {
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
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal)

            VStack(spacing: 20) {
                // Option: Anywhere in Holland
                Button(action: {
                    onLocationSelected("Anywhere in Holland")
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "globe")
                            .foregroundColor(Constants.Design.secondaryColor)
                            .font(.title3)
                        Text("Anywhere in Holland")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Constants.Design.secondaryColor)
                        Spacer()
                    }
                    .padding()
                }

                // Option: Current Location
                Button(action: {
                    onLocationSelected(viewModel.currentLocation)
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .foregroundColor(Constants.Design.secondaryColor)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current location")
                                .font(.custom("Poppins-SemiBold", size: 16))
                                .foregroundColor(.black)
                            Text(viewModel.currentLocation)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .padding(.horizontal)

            // Display Filtered Cities While Typing
            if !viewModel.filteredCities.isEmpty {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.filteredCities, id: \.self) { city in
                            Button(action: {
                                onLocationSelected(city)
                                dismiss()
                            }) {
                                HStack {
                                    Text(city)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(Constants.Design.primaryColor)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Spacer()
            }

            Spacer()
        }
        .padding(.top, 20)
        .onAppear {
            viewModel.fetchCurrentLocation()
        }
    }
}

#Preview {
    LocationView { selectedLocation in
        print("Selected Location: \(selectedLocation)")
    }
}
