import Foundation
import Combine

/// Protocol defining methods for fetching events.
protocol EventRepositoryProtocol {
    /// Fetches a list of events based on filters like location, date, sort order, and categories.
    /// - Parameters:
    ///   - location: The city or venue where the events are located.
    ///   - date: The date of the events.
    ///   - sort: Sorting criteria for the events (e.g., by popularity or date).
    ///   - categories: The categories of the events (e.g., concerts, sports).
    /// - Returns: A publisher that emits an array of `Event` objects or an error.
    func fetchEvents(location: String, date: String, sort: String, categories: String) -> AnyPublisher<[Event], Error>

    /// Fetches details for a specific event by its ID.
    /// - Parameter id: The unique identifier of the event.
    /// - Returns: A publisher that emits an `Event` object or an error.
    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error>
}

/// Implementation of `EventRepositoryProtocol` that fetches events from an API.
class EventRepository: EventRepositoryProtocol {
    private let apiService = APIService.shared // Shared instance of the API service.
    private let baseURL = URL(string: "https://api.tiqzyapi.nl/tickets/tickets")! // Base URL for the events API.

    /// Fetches a list of events based on filters like location, date, sort order, and categories.
    func fetchEvents(location: String, date: String, sort: String, categories: String) -> AnyPublisher<[Event], Error> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        // Add query parameters for filters if they are provided.
        var queryItems: [URLQueryItem] = []
        if !location.isEmpty {
            queryItems.append(URLQueryItem(name: "venueCity", value: location))
        }
        if !date.isEmpty {
            queryItems.append(URLQueryItem(name: "date", value: date))
        }
        if !sort.isEmpty {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        if !categories.isEmpty {
            queryItems.append(URLQueryItem(name: "categories", value: categories))
        }
        components.queryItems = queryItems

        // Ensure the URL is valid, otherwise return an error.
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        // Use the API service to fetch events and return the result as a publisher.
        return apiService.request(url, type: [Event].self)
            .mapError { $0 as Error } // Map errors to `Error` type.
            .eraseToAnyPublisher()
    }

    /// Fetches details for a specific event by its ID.
    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error> {
        // Construct the URL by appending the event ID to the base URL.
        let url = baseURL.appendingPathComponent("\(id)")

        // Use the API service to fetch the event and return the result as a publisher.
        return apiService.request(url, type: Event.self)
            .mapError { $0 as Error } // Map errors to `Error` type.
            .eraseToAnyPublisher()
    }
}
