import Foundation
import SwiftData

@Model
class Event: Identifiable, Codable, Equatable {
    @Attribute(.unique) var id: Int // Unique identifier for the event
    var title: String
    var summary: String // Renamed from `description` to `summary`
    var startDate: String
    var endDate: String
    var venueAddress: String?
    var location: String?
    var duration: Int
    var imageURL: String?
    var price: Double?
    var stock: Int // For regular events
    var category: String?
    var isFavorite: Bool = false // Tracks if this event is favorited

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case id, title, summary = "description", stock, price, duration_minutes
        case startDate = "start_date"
        case endDate = "end_date"
        case venue
        case image
        case category
    }

    private enum VenueCodingKeys: String, CodingKey {
        case address
        case city
    }

    private enum ImageCodingKeys: String, CodingKey {
        case url
    }

    // MARK: - Initializer for Regular and Favorite Events
    init(
        id: Int,
        title: String,
        summary: String,
        startDate: String,
        endDate: String,
        venueAddress: String? = nil,
        location: String? = nil,
        duration: Int,
        imageURL: String? = nil,
        price: Double? = nil,
        stock: Int = 0,
        category: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.startDate = startDate
        self.endDate = endDate
        self.venueAddress = venueAddress
        self.location = location
        self.duration = duration
        self.imageURL = imageURL
        self.price = price
        self.stock = stock
        self.category = category
        self.isFavorite = isFavorite
    }

    // MARK: - Codable Conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode top-level fields
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        // Use a temporary variable for `description` processing
        let rawDescription = try container.decode(String.self, forKey: .summary)
        summary = rawDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)

        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        stock = try container.decode(Int.self, forKey: .stock)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        duration = try container.decode(Int.self, forKey: .duration_minutes)
        category = try container.decodeIfPresent(String.self, forKey: .category)

        // Decode nested venue fields
        if let venueContainer = try? container.nestedContainer(keyedBy: VenueCodingKeys.self, forKey: .venue) {
            venueAddress = try venueContainer.decodeIfPresent(String.self, forKey: .address)
            location = try venueContainer.decodeIfPresent(String.self, forKey: .city)
        } else {
            venueAddress = nil
            location = nil
        }

        // Decode nested image URL
        if let imageContainer = try? container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image) {
            imageURL = try imageContainer.decodeIfPresent(String.self, forKey: .url)
        } else {
            imageURL = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode top-level fields
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(summary, forKey: .summary)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(stock, forKey: .stock)
        try container.encode(duration, forKey: .duration_minutes)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(category, forKey: .category)

        // Encode nested venue fields
        var venueContainer = container.nestedContainer(keyedBy: VenueCodingKeys.self, forKey: .venue)
        try venueContainer.encodeIfPresent(venueAddress, forKey: .address)
        try venueContainer.encodeIfPresent(location, forKey: .city)

        // Encode nested image URL
        var imageContainer = container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        try imageContainer.encodeIfPresent(imageURL, forKey: .url)
    }

    // MARK: - Equatable
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
