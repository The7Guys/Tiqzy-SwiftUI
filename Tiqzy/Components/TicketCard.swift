import SwiftUI

/// A card view representing a ticket with basic details and an image.
/// Provides a tap gesture to trigger a QR code popup.
struct TicketCard: View {
    /// The ticket associated with this card.
    let ticket: Ticket

    /// Callback function triggered when the card is tapped.
    let qrCodeTapped: () -> Void

    /// Tracks the press state of the card for scaling animation.
    @State private var isPressed: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Ticket Info Section
            VStack(alignment: .leading, spacing: 8) {
                // Ticket name
                Text(ticket.name)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(1)

                // Ticket date
                Text("Date: \(ticket.date)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)

                // Ticket timeframe
                Text("Timeframe: \(ticket.timeframe)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // MARK: - Ticket Image Section
            AsyncImage(url: URL(string: ticket.imageURL)) { phase in
                switch phase {
                case .empty:
                    // Show a progress view while the image is loading.
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    // Display the successfully loaded image.
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                case .failure:
                    // Show a placeholder image if loading fails.
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView() // Handle unexpected cases.
                }
            }
        }
        .padding()
        .background(
            // Background with a subtle gradient.
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15) // Rounded corners for the card.
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5) // Add shadow for elevation.
        .padding(.horizontal) // Horizontal padding for spacing.
        .scaleEffect(isPressed ? 0.95 : 1.0) // Apply a scaling effect when the card is tapped.
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.2), value: isPressed) // Smooth spring animation for scaling.
        .onTapGesture {
            isPressed = true // Trigger the scale down animation on tap.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false // Reset the scale after the tap.
                qrCodeTapped() // Trigger the QR code popup action.
            }
        }
    }
}
