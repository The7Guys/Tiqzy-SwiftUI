import Foundation

enum Category: String, Codable, CaseIterable, Hashable {
    case museums = "Museums"
    case concerts = "Concerts"
    case exhibitions = "Exhibitions"
    case sports = "Sports"
    case workshops = "Workshops"
    case theater = "Theater"
    case festivals = "Festivals"
    case conferences = "Conferences"
    case networking = "Networking"
    case comedy = "Comedy"
    case magicShows = "Magic Shows"
    case outdoor = "Outdoor Activities"
    case foodAndDrink = "Food & Drink"
    case charity = "Charity Events"
    case fairs = "Fairs"
    case gaming = "Gaming"
    case technology = "Technology"
    case art = "Art"
    case dance = "Dance"
    case literature = "Literature"
    case science = "Science"
    case children = "Children's Events"
    case historical = "Historical"
    case film = "Film & Movies"
    var description: String {
        self.rawValue
    }
}
