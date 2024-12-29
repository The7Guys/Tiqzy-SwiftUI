import SwiftUI

struct EventDetailView: View {
    @StateObject private var viewModel: EventDetailViewModel
    let eventID: Int // Passed from the list view or navigation
    @State private var showMapDialog = false // State for showing the dialog
    @Environment(\.dismiss) private var dismiss // Environment dismiss action
    @State private var showShareSheet = false // State for triggering share sheet

    init(eventID: Int) {
        self.eventID = eventID
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(eventID: eventID))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    // Event Image
                    AsyncImage(url: URL(string: viewModel.event?.imageURL ?? "")) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder while loading
                            Image("EventImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 32, height: 400) // Adjust width and height
                                .clipped()
                                .cornerRadius(12)
                        case .success(let image):
                            // Successfully loaded image
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 32, height: 400) // Adjust width and height
                                .clipped()
                                .cornerRadius(12)
                        case .failure:
                            // Failed to load, show fallback
                            Image("EventImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 32, height: 400) // Adjust width and height
                                .clipped()
                                .cornerRadius(12)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    // Top-right "X" Button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                dismiss() // Navigate back to the previous page
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width:12, height: 12)
                                    .padding()
                                    .background(Circle().fill(Color.black))
                            }
                            .padding(16)
                        }
                        Spacer()
                    }

                    // Bottom-right action buttons
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            HStack(spacing: 16) {
                                Button(action: {
                                    // Favorite action
                                }) {
                                    Image(systemName: "heart")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Circle().fill(Color.black))
                                }

                                Button(action: {
                                    showMapDialog = true // Show dialog
                                }) {
                                    Image(systemName: "map")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Circle().fill(Color.black))
                                }

                                Button(action: {
                                    showShareSheet = true // Trigger share sheet
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title2)
                                        .offset(y: -2)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Circle().fill(Color.black))
                                }
                            }
                            .padding(16)
                        }
                    }
                    
                }
                .padding(.horizontal)

                // Event Title
                Text(viewModel.event?.title ?? "Loading...")
                    .font(.custom("Poppins-Regular", size: 28)) // Larger font size
                    .foregroundColor(Constants.Design.primaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Price Section
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(Constants.Design.primaryColor)
                    Text(viewModel.event?.location ?? "Loading location...")
                        .font(.custom("Poppins-Regular", size: 18)) // Larger font size
                        .foregroundColor(Constants.Design.primaryColor)
                    Spacer()
                    Text("from")
                        .font(.custom("Poppins-Regular", size: 14)) // Larger font size
                        .foregroundColor(Constants.Design.primaryColor)
                        .offset(y: 5)
                    Text(
                        viewModel.event != nil ? "\(String(format: "%.2f€", viewModel.event!.price!))" : "Loading price..."
                    )
                        .font(.custom("Poppins-Regular", size: 28)) // Larger font size
                        .foregroundColor(Constants.Design.primaryColor)
                }
                .padding(.horizontal)

                // Check Availability Button
                Button(action: {
                    // Add functionality for availability check
                }) {
                    Text("Check availability")
                        .font(.custom("Poppins-Medium", size: 24)) // Larger font size
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Constants.Design.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                //Spacer()
                // Event Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.event?.description ?? "Loading description...")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Constants.Design.primaryColor)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .confirmationDialog("Open Maps?", isPresented: $showMapDialog, titleVisibility: .visible) {
            Button("Open in Apple Maps") {
                if let url = viewModel.appleMapsURL() {
                    UIApplication.shared.open(url)
                }
            }
            Button("Open in Google Maps") {
                if let url = viewModel.googleMapsURL() {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: viewModel.generateShareContent())
        }
        .onAppear {
            viewModel.loadEventDetails()
        }
        .navigationBarHidden(true)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    EventDetailView(eventID: 1762)
}
