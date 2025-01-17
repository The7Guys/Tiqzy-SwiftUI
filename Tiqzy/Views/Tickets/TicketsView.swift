import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TicketsView: View {
    @StateObject private var viewModel = TicketsViewModel() // ViewModel instance
    @State private var selectedTicket: Ticket? // For the QR code popup
    @State private var navigateToLogin = false // For navigation to LoginView
    @ObservedObject private var appState = AppState.shared // Observe ticket count

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Loading State
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                } else if !viewModel.isLoggedIn {
                    // Not Logged In State
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)

                        Text("You need to log in to view your tickets.")
                            .font(.custom("Poppins-Regular", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)

                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Log In")
                                .font(.custom("Poppins-SemiBold", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Constants.Design.primaryColor)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 40)
                } else if viewModel.tickets.isEmpty {
                    // No Tickets State
                    VStack(spacing: 16) {
                        Image(systemName: "ticket.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)

                        Text("No tickets available.")
                            .font(.custom("Poppins-Regular", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)
                } else {
                    // Tickets List (Scrollable)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Header Title
                            Text("Your Tickets")
                                .font(.custom("Poppins-SemiBold", size: 24))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(.top)

                            // Grouped Tickets
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
                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
                }
            }
            .overlay(
                Group {
                    if let ticket = selectedTicket {
                        QRCodePopup(ticket: ticket) {
                            selectedTicket = nil // Dismiss the popup
                        }
                    }
                }
            )
            .onAppear {
                // Reset ticket count
                appState.newTicketCount = 0
                
                // Fetch tickets
                viewModel.fetchTickets()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }

    // MARK: - Group Tickets by Date
    private func groupTicketsByDate() -> [(key: String, value: [Ticket])] {
        let grouped = Dictionary(grouping: viewModel.tickets, by: { $0.date })
        return grouped.sorted { $0.key < $1.key }
    }
}
