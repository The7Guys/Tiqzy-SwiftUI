import FirebaseAuth
import FirebaseFirestore
import SwiftUI

/// ViewModel for managing tickets in the `TicketsView`.
/// Handles fetching tickets, managing login state, and responding to authentication changes.
final class TicketsViewModel: ObservableObject {
    @Published var tickets: [Ticket] = [] // List of fetched tickets
    @Published var errorMessage: String? = nil // Stores error messages, if any
    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil // Tracks whether the user is logged in
    @Published var isLoading: Bool = false // Indicates if tickets are being fetched

    private let ticketService = TicketService() // Service to interact with Firebase Firestore
    private var authStateListener: AuthStateDidChangeListenerHandle? // Listener for authentication state changes

    // MARK: - Initialization
    init() {
        addAuthStateListener() // Start listening to authentication changes
        if isLoggedIn { fetchTickets() } // Fetch tickets if the user is already logged in
    }

    deinit {
        removeAuthStateListener() // Clean up the auth state listener
    }

    // MARK: - Fetch Tickets
    /// Fetches tickets for the currently logged-in user.
    func fetchTickets() {
        isLoading = true // Start loading state
        ticketService.fetchUserTickets { [weak self] fetchedTickets, error in
            DispatchQueue.main.async {
                self?.isLoading = false // Stop loading state
                if let error = error {
                    // Handle error and clear tickets
                    self?.errorMessage = error.localizedDescription
                    self?.tickets = []
                } else {
                    // Successfully fetch tickets
                    self?.tickets = fetchedTickets ?? []
                    self?.errorMessage = nil
                }
            }
        }
    }

    // MARK: - Authentication State Listener
    /// Adds a listener for authentication state changes to keep track of login state.
    private func addAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil // Update login state
                if self?.isLoggedIn == true {
                    // Fetch tickets if the user logs in
                    self?.fetchTickets()
                } else {
                    // Clear tickets if the user logs out
                    self?.tickets = []
                }
            }
        }
    }

    /// Removes the authentication state listener.
    private func removeAuthStateListener() {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
