import SwiftUI
import SwiftData

struct TicketsView: View {
    @Query private var tickets: [Ticket] // Fetch tickets

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
                                ModernTicketCard(ticket: ticket)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    // Group tickets by string-based date
    private func groupTicketsByDate() -> [(key: String, value: [Ticket])] {
        let grouped = Dictionary(grouping: tickets, by: { $0.date }) // Group by the string-based date
        return grouped.sorted { $0.key < $1.key }
    }
}

struct ModernTicketCard: View {
    let ticket: Ticket

    var body: some View {
        HStack(spacing: 16) {
            // QR Code Section (Placeholder for QR Code)
            Image(systemName: "qrcode")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(Color.white)
                .cornerRadius(10)

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
