import Foundation

struct Ticket: Identifiable {
    let id: String
    let userId: String
    let name: String
    let imageURL: String
    let location: String
    let date: String
    let timeframe: String

    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.userId = dictionary["userId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? "Unknown Event"
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? "Unknown Location"
        self.date = dictionary["date"] as? String ?? "Unknown Date"
        self.timeframe = dictionary["timeframe"] as? String ?? "Unknown Timeframe"
    }

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
