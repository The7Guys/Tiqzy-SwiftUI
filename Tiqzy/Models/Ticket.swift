import Foundation
import SwiftData

@Model
class Ticket: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var imageUrl: String
    var location: String
    var date: String
    var duration: Int
    var price: Double
    
    init(
        id: String,
        name: String,
        imageUrl: String,
        location: String,
        date: String,
        duration: Int,
        price: Double
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.location = location
        self.date = date
        self.duration = duration
        self.price = price
    }
}
