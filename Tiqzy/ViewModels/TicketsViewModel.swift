import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class TicketsViewModel: ObservableObject {
    @Published var tickets: [Ticket] = [] // Fetched tickets
    @Published var errorMessage: String? = nil // Error messages
    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil // Tracks login state
    @Published var isLoading: Bool = false // Loading state

    private let ticketService = TicketService() // Firebase service
    private var authStateListener: AuthStateDidChangeListenerHandle? // Listener handle

    init() {
        addAuthStateListener() // Start listening to auth changes
        if isLoggedIn { fetchTickets() } // Fetch tickets if logged in
    }

    deinit {
        removeAuthStateListener() // Cleanup the listener
    }

    // MARK: - Fetch Tickets
    func fetchTickets() {
        isLoading = true
        ticketService.fetchUserTickets { [weak self] fetchedTickets, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.tickets = [] // Clear tickets on error
                } else {
                    self?.tickets = fetchedTickets ?? []
                    self?.errorMessage = nil // Clear any previous errors
                }
            }
        }
    }

    // MARK: - Auth State Listener
    private func addAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
                if self?.isLoggedIn == true {
                    self?.fetchTickets() // Fetch tickets when user logs in
                } else {
                    self?.tickets = [] // Clear tickets when logged out
                }
            }
        }
    }

    private func removeAuthStateListener() {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
