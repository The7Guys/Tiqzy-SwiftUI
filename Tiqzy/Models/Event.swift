import Foundation

struct Event: Identifiable, Codable {
    let id: Int
    let title: String
    var description: String
    let startDate: String
    let endDate: String
    let venueAddress: String?
    let location: String? // Added city
    let duration: Int
    let imageURL: String?
    let price: Double?
    let stock: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, description, stock, price, duration_minutes
        case startDate = "start_date"
        case endDate = "end_date"
        case venue
        case image
    }

    private enum VenueCodingKeys: String, CodingKey {
        case address
        case city // Added city key
    }

    private enum ImageCodingKeys: String, CodingKey {
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode top-level fields
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        description = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression) // Remove HTML tags
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        stock = try container.decode(Int.self, forKey: .stock)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        duration = try container.decode(Int.self, forKey: .duration_minutes)

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
        try container.encode(description, forKey: .description)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(stock, forKey: .stock)
        try container.encode(duration, forKey: .duration_minutes)
        try container.encodeIfPresent(price, forKey: .price)

        // Encode nested venue fields
        var venueContainer = container.nestedContainer(keyedBy: VenueCodingKeys.self, forKey: .venue)
        try venueContainer.encodeIfPresent(venueAddress, forKey: .address)
        try venueContainer.encodeIfPresent(location, forKey: .city)

        // Encode nested image URL
        var imageContainer = container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        try imageContainer.encodeIfPresent(imageURL, forKey: .url)
    }
}
