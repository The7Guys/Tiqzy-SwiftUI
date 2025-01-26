import FirebaseFirestore
import FirebaseAuth

/// A service for managing user tickets in Firestore.
final class TicketService {
    /// Reference to the Firestore database.
    private let db = Firestore.firestore()

    /// Adds a ticket for the currently authenticated user.
    /// - Parameters:
    ///   - ticket: The `Ticket` object to be added.
    ///   - completion: A closure called with an error if the operation fails.
    func addTicket(_ ticket: Ticket, completion: @escaping (Error?) -> Void) {
        // Ensure a user is logged in.
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No User", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        // Convert the ticket to a dictionary and set the correct userId.
        var ticketData = ticket.toDictionary()
        ticketData["userId"] = userId

        // Save the ticket data to Firestore under the "tickets" collection.
        db.collection("tickets").document(ticket.id).setData(ticketData) { error in
            completion(error)
        }
    }

    /// Fetches all tickets associated with the currently authenticated user.
    /// - Parameter completion: A closure called with the list of `Ticket` objects or an error if the operation fails.
    func fetchUserTickets(completion: @escaping ([Ticket]?, Error?) -> Void) {
        // Ensure a user is logged in.
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "No User", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        // Query Firestore for tickets where the userId matches the current user's ID.
        db.collection("tickets")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                // Map the Firestore documents to `Ticket` objects.
                let tickets = snapshot?.documents.compactMap { doc in
                    return Ticket(from: doc.data())
                }
                completion(tickets, nil)
            }
    }
}
