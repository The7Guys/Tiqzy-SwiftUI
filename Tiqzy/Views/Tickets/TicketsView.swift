import SwiftUI
import SwiftData

struct TicketsView: View {
    @Query private var tickets: [Ticket] // Fetch tickets
    @State private var selectedTicket: Ticket? // To store the selected ticket for the popup
    @ObservedObject private var appState = AppState.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your tickets")
                    .font(.custom("Poppins-SemiBold", size: 24))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.top)

                if tickets.isEmpty {
                    Text("No tickets available.")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ForEach(groupTicketsByDate(), id: \.key) { date, ticketsForDate in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(date) // Display the string-based date
                                .font(.custom("Poppins-SemiBold", size: 18))
                                .foregroundColor(.black)
                                .padding(.horizontal)

                            ForEach(ticketsForDate) { ticket in
                                ModernTicketCard(ticket: ticket) {
                                    selectedTicket = ticket // Set the selected ticket for the popup
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
                    // Reset the badge count when the user views this tab
                    appState.newTicketCount = 0
                }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .overlay(
            // Show the QR code popup when a ticket is selected
            Group {
                if let ticket = selectedTicket {
                    QRCodePopup(ticket: ticket) {
                        selectedTicket = nil // Dismiss the popup
                    }
                }
            }
        )
    }

    // Group tickets by string-based date
    private func groupTicketsByDate() -> [(key: String, value: [Ticket])] {
        let grouped = Dictionary(grouping: tickets, by: { $0.date }) // Group by the string-based date
        return grouped.sorted { $0.key < $1.key }
    }
}

struct ModernTicketCard: View {
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
            AsyncImage(url: URL(string: ticket.imageUrl)) { phase in
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

// MARK: - QR Code Popup
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

                Button(action: dismissAction) {
                    Text("Close")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Constants.Design.secondaryColor)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}
