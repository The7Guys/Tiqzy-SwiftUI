import Foundation
import SwiftData

/// Represents an event, including details such as title, summary, dates, venue, and more.
/// The `Event` class conforms to `Identifiable`, `Codable`, and `Equatable` for seamless
/// identification, serialization, and comparison.
@Model
class Event: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    /// Unique identifier for the event.
    @Attribute(.unique) var id: Int
    
    /// The title of the event.
    var title: String
    
    /// A short summary of the event. Decoded from `description` in the JSON payload.
    var summary: String
    
    /// Start date of the event.
    var startDate: String
    
    /// End date of the event.
    var endDate: String
    
    /// The address of the venue where the event is held.
    var venueAddress: String?
    
    /// The city or location of the event.
    var location: String?
    
    /// Duration of the event in minutes.
    var duration: Int
    
    /// URL of the event's image.
    var imageURL: String?
    
    /// Price of the event. Can be `nil` if the event is free.
    var price: Double?
    
    /// Number of tickets or seats available.
    var stock: Int
    
    /// The category of the event (e.g., Concerts, Sports).
    var category: String?
    
    /// Tracks whether the event is marked as a favorite by the user.
    var isFavorite: Bool = false
    
    // MARK: - Coding Keys
    
    /// Maps JSON keys to Swift property names for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id, title, summary = "description", stock, price, duration_minutes
        case startDate = "start_date"
        case endDate = "end_date"
        case venue
        case image
        case category
    }
    
    /// Keys for decoding/encoding the nested venue fields.
    private enum VenueCodingKeys: String, CodingKey {
        case address
        case city
    }
    
    /// Keys for decoding/encoding the nested image fields.
    private enum ImageCodingKeys: String, CodingKey {
        case url
    }
    
    // MARK: - Initializer
    
    /// Initializes a new `Event` instance.
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
    
    /// Decodes an `Event` instance from a JSON payload.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode top-level fields
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        // Decode `description` and sanitize it
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
        
        // Decode nested image fields
        if let imageContainer = try? container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image) {
            imageURL = try imageContainer.decodeIfPresent(String.self, forKey: .url)
        } else {
            imageURL = nil
        }
    }
    
    /// Encodes an `Event` instance into a JSON payload.
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
        
        // Encode nested image fields
        var imageContainer = container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        try imageContainer.encodeIfPresent(imageURL, forKey: .url)
    }
    
    // MARK: - Equatable
    
    /// Compares two `Event` instances for equality.
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
