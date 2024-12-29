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
    case webinars = "Webinars"
    case meetups = "Meetups"
    case comedy = "Comedy"
    case magicShows = "Magic Shows"
    case outdoor = "Outdoor Activities"
    case foodAndDrink = "Food & Drink"
    case charity = "Charity Events"
    case fairs = "Fairs"
    case gaming = "Gaming"
    case technology = "Technology"
    case healthAndWellness = "Health & Wellness"
    case art = "Art"
    case dance = "Dance"
    case literature = "Literature"
    case science = "Science"
    case children = "Children's Events"
    case historical = "Historical"
    case film = "Film & Movies"
    case travel = "Travel"
    case photography = "Photography"
    case spirituality = "Spirituality"
    
    var description: String {
        self.rawValue
    }
}
