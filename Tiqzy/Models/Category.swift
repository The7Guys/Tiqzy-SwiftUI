import Foundation

/// Represents different categories of events.
///
/// This enum is used to classify events into specific categories, making it easier
/// to filter, sort, or display events in the app. Each case represents a distinct
/// event type, such as museums, concerts, workshops, etc.
enum Category: String, Codable, CaseIterable, Hashable {
    
    // MARK: - Event Categories
    case museums = "Museums"                     // Events related to museums
    case concerts = "Concerts"                   // Music concerts or live performances
    case exhibitions = "Exhibitions"             // Art, photography, or other exhibitions
    case sports = "Sports"                       // Sports events or games
    case workshops = "Workshops"                 // Hands-on or educational workshops
    case theater = "Theater"                     // Plays, dramas, or stage performances
    case festivals = "Festivals"                 // Festivals like music, cultural, or food festivals
    case conferences = "Conferences"             // Professional or industry-specific conferences
    case networking = "Networking"               // Networking or business-related events
    case comedy = "Comedy"                       // Comedy shows or stand-up performances
    case magicShows = "Magic Shows"              // Magic or illusion performances
    case outdoor = "Outdoor Activities"          // Events like hiking, camping, or outdoor adventures
    case foodAndDrink = "Food & Drink"           // Food tastings, wine events, or dining experiences
    case charity = "Charity Events"              // Charity or fundraising events
    case fairs = "Fairs"                         // Local fairs or carnivals
    case gaming = "Gaming"                       // Gaming conventions or esports tournaments
    case technology = "Technology"               // Tech expos or hackathons
    case art = "Art"                             // Art-related events, such as galleries or installations
    case dance = "Dance"                         // Dance performances or workshops
    case literature = "Literature"               // Book fairs, author readings, or literature events
    case science = "Science"                     // Science expos, lectures, or workshops
    case children = "Children's Events"          // Events specifically for children or families
    case historical = "Historical"               // Historical reenactments, tours, or events
    case film = "Film & Movies"                  // Film screenings, festivals, or movie events
    
    // MARK: - Description
    /// A human-readable description of the category.
    var description: String {
        self.rawValue
    }
}
