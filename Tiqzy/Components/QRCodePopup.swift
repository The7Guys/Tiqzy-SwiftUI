import SwiftUI
import MapKit

struct QRCodePopup: View {
    let ticket: Ticket
    let dismissAction: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissAction() // Dismiss when tapping outside the popup
                }

            // Popup content
            VStack(spacing: 16) {
                Image("QR") // Use the "QR" image from assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)

                Text(ticket.name)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.black)

                HStack(spacing: 16) {
                    // Close Button
                    Button(action: dismissAction) {
                        Text("Close")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                    }

                    // Go to Maps Button
                    Button(action: openAppleMaps) {
                        Text("Go to Maps")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.primaryColor)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }

    // MARK: - Open Apple Maps
    private func openAppleMaps() {
        guard let encodedLocation = ticket.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://maps.apple.com/?q=\(encodedLocation)") else {
            print("Invalid location")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open Apple Maps")
        }
    }
}