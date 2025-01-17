import FirebaseFirestore
import FirebaseAuth

final class TicketService {
    private let db = Firestore.firestore()

    /// Adds a ticket for the current user.
    func addTicket(_ ticket: Ticket, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "No User", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        var ticketData = ticket.toDictionary()
        ticketData["userId"] = userId // Ensure the correct userId is assigned

        db.collection("tickets").document(ticket.id).setData(ticketData) { error in
            completion(error)
        }
    }

    /// Fetches tickets for the current user.
    func fetchUserTickets(completion: @escaping ([Ticket]?, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "No User", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        db.collection("tickets")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                let tickets = snapshot?.documents.compactMap { doc in
                    return Ticket(from: doc.data())
                }
                completion(tickets, nil)
            }
    }
}
