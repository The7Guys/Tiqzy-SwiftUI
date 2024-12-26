import Foundation

struct Order: Codable {
    var emailAddress: String?
    var userName: String
    var userId: String
    var orderItems: [OrderItem]

    struct OrderItem: Codable {
        var itemId: String
        var quantity: Int
        var timeslot: String
        var price: Double
    }
}

