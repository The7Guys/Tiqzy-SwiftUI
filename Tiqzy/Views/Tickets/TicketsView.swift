import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TicketsView: View {
    @State private var tickets: [Ticket] = [] // Holds fetched tickets
    @State private var selectedTicket: Ticket? // For the QR code popup
    @State private var errorMessage: String? // Holds error messages
    @State private var isLoading: Bool = false // For loading state
    private let ticketService = TicketService() // Instance of TicketService
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Tickets")
                    .font(.custom("Poppins-SemiBold", size: 24))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.top)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if tickets.isEmpty {
                    VStack(spacing: 16) {
                        Text("No tickets available.")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                } else {
                    ForEach(groupTicketsByDate(), id: \.key) { date, ticketsForDate in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(date) // Display the grouped date
                                .font(.custom("Poppins-SemiBold", size: 18))
                                .foregroundColor(.black)
                                .padding(.horizontal)

                            ForEach(ticketsForDate) { ticket in
                                TicketCard(ticket: ticket) {
                                    selectedTicket = ticket // Set selected ticket for popup
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            appState.newTicketCount = 0 // Reset badge count
            fetchTickets() // Fetch tickets on load
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .overlay(
            Group {
                if let ticket = selectedTicket {
                    QRCodePopup(ticket: ticket) {
                        selectedTicket = nil // Dismiss the popup
                    }
                }
            }
        )
    }

    // Group tickets by their date field
    private func groupTicketsByDate() -> [(key: String, value: [Ticket])] {
        let grouped = Dictionary(grouping: tickets, by: { $0.date })
        return grouped.sorted { $0.key < $1.key }
    }

    // Fetch tickets using TicketService
    private func fetchTickets() {
        isLoading = true
        ticketService.fetchUserTickets { fetchedTickets, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                tickets = fetchedTickets ?? []
                errorMessage = nil
            }
        }
    }
}
