import SwiftUI
import FirebaseFirestore
import FirebaseAuth

/// A view that displays the user's tickets.
/// Handles states for loading, logged-out users, no tickets, and displaying ticket information.
struct TicketsView: View {
    @StateObject private var viewModel = TicketsViewModel() // ViewModel instance to manage tickets
    @State private var selectedTicket: Ticket? // Tracks the ticket for which the QR code popup is displayed
    @State private var navigateToLogin = false // Tracks navigation to the LoginView
    @ObservedObject private var appState = AppState.shared // Observes the app state to reset ticket count

    var body: some View {
        NavigationStack {
            Group {
                // MARK: - Loading State
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                // MARK: - Not Logged In State
                else if !viewModel.isLoggedIn {
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
                            navigateToLogin = true // Navigate to LoginView
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
                }
                // MARK: - No Tickets State
                else if viewModel.tickets.isEmpty {
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
                }
                // MARK: - Tickets List
                else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Title
                            Text("Your Tickets")
                                .font(.custom("Poppins-SemiBold", size: 24))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(.top)

                            // Grouped Tickets by Date
                            ForEach(groupTicketsByDate(), id: \.key) { date, ticketsForDate in
                                VStack(alignment: .leading, spacing: 16) {
                                    // Date Header
                                    Text(date)
                                        .font(.custom("Poppins-SemiBold", size: 18))
                                        .foregroundColor(.black)
                                        .padding(.horizontal)

                                    // Tickets for the Date
                                    ForEach(ticketsForDate) { ticket in
                                        TicketCard(ticket: ticket) {
                                            selectedTicket = ticket // Show QR code popup for this ticket
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .background(Color(.systemGroupedBackground).ignoresSafeArea())
                }
            }
            // MARK: - QR Code Popup Overlay
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
                // Reset ticket count in app state
                appState.newTicketCount = 0

                // Fetch tickets from ViewModel
                viewModel.fetchTickets()
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView() // Navigate to the login view
            }
        }
    }

    // MARK: - Helper: Group Tickets by Date
    /// Groups tickets by their `date` property.
    /// - Returns: An array of tuples containing the date as the key and the associated tickets as the value.
    private func groupTicketsByDate() -> [(key: String, value: [Ticket])] {
        let grouped = Dictionary(grouping: viewModel.tickets, by: { $0.date })
        return grouped.sorted { $0.key < $1.key } // Sort dates in ascending order
    }
}
