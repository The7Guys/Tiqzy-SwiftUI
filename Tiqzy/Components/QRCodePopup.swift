import SwiftUI
import MapKit

/// A popup view displaying a QR code for a ticket, along with options to dismiss or open the location in Apple Maps.
struct QRCodePopup: View {
    /// The ticket associated with the QR code.
    let ticket: Ticket
    
    /// Action to dismiss the popup.
    let dismissAction: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background to focus on the popup
            Color.black.opacity(0.5)
                .ignoresSafeArea() // Covers the entire screen
                .onTapGesture {
                    dismissAction() // Dismiss the popup when tapping outside
                }

            // Popup content
            VStack(spacing: 16) {
                // QR Code Image
                Image("QR") // Use the "QR" image from assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)

                // Ticket name
                Text(ticket.name)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.black)

                // Action buttons
                HStack(spacing: 16) {
                    // Close Button
                    Button(action: dismissAction) {
                        Text("Close")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.secondaryColor) // Secondary color for styling
                            .cornerRadius(12)
                    }

                    // Go to Maps Button
                    Button(action: openAppleMaps) {
                        Text("Go to Maps")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.primaryColor) // Primary color for styling
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color.white) // Background color for the popup
            .cornerRadius(20) // Rounded corners for the popup
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5) // Add a subtle shadow
        }
    }

    // MARK: - Open Apple Maps
    /// Opens the ticket's location in Apple Maps.
    private func openAppleMaps() {
        // Encode the location to make it URL-safe.
        guard let encodedLocation = ticket.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://maps.apple.com/?q=\(encodedLocation)") else {
            print("Invalid location") // Handle invalid location
            return
        }

        // Open the URL in Apple Maps if possible.
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open Apple Maps") // Handle the case where Apple Maps cannot be opened
        }
    }
}
