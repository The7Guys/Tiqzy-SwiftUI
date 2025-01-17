import SwiftUI

struct TicketCard: View {
    let ticket: Ticket
    let qrCodeTapped: () -> Void // Callback for when the QR code is tapped

    var body: some View {
        HStack(spacing: 16) {
            // QR Code Section
            Image("QR") // Use the "QR" image from assets
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .onTapGesture {
                    qrCodeTapped() // Trigger the callback
                }

            // Ticket Info Section
            VStack(alignment: .leading, spacing: 8) {
                Text(ticket.name)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text("Date: \(ticket.date)") // Use the string-based date directly
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Ticket Image Section
            AsyncImage(url: URL(string: ticket.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}
