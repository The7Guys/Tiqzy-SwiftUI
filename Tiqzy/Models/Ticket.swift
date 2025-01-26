import Foundation

/// Represents a ticket for an event.
struct Ticket: Identifiable {
    /// Unique identifier for the ticket.
    let id: String
    
    /// The user ID associated with the ticket.
    let userId: String
    
    /// The name of the event for which the ticket is issued.
    let name: String
    
    /// The URL of the event's image.
    let imageURL: String
    
    /// The location of the event.
    let location: String
    
    /// The date of the event.
    let date: String
    
    /// The selected timeframe for the event.
    let timeframe: String

    /// Initializes a `Ticket` from a dictionary of key-value pairs.
    /// - Parameter dictionary: A dictionary containing ticket information.
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString // Generates a unique ID if none exists
        self.userId = dictionary["userId"] as? String ?? "" // Defaults to an empty string if not provided
        self.name = dictionary["name"] as? String ?? "Unknown Event"
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? "Unknown Location"
        self.date = dictionary["date"] as? String ?? "Unknown Date"
        self.timeframe = dictionary["timeframe"] as? String ?? "Unknown Timeframe"
    }

    /// Converts the `Ticket` instance into a dictionary representation.
    /// - Returns: A dictionary containing ticket information.
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "name": name,
            "imageURL": imageURL,
            "location": location,
            "date": date,
            "timeframe": timeframe
        ]
    }
}
