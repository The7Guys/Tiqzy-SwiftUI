import SwiftData
import Foundation

@Model
class FavoriteEvent {
    @Attribute(.unique) var id: Int // Unique identifier for the event
    var title: String
    var summary: String
    var startDate: String
    var endDate: String
    var venueAddress: String?
    var location: String?
    var duration: Int
    var imageURL: String?
    var price: Double?
    var category: String?

    init(
        id: Int,
        title: String,
        description: String,
        startDate: String,
        endDate: String,
        venueAddress: String? = nil,
        location: String? = nil,
        duration: Int,
        imageURL: String? = nil,
        price: Double? = nil,
        category: String? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = description
        self.startDate = startDate
        self.endDate = endDate
        self.venueAddress = venueAddress
        self.location = location
        self.duration = duration
        self.imageURL = imageURL
        self.price = price
        self.category = category
    }
}
