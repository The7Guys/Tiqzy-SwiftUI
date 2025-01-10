import Foundation
import Combine

protocol EventRepositoryProtocol {
    func fetchEvents(location: String, date: String, sort: String) -> AnyPublisher<[Event], Error>
    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error>
}

class EventRepository: EventRepositoryProtocol {
    private let apiService = APIService.shared
    private let baseURL = URL(string: "https://api.tiqzyapi.nl/tickets/tickets")!

    func fetchEvents(location: String, date: String, sort: String) -> AnyPublisher<[Event], Error> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        // Add query items only for non-empty filters
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
        components.queryItems = queryItems

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return apiService.request(url, type: [Event].self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error> {
        let url = baseURL.appendingPathComponent("\(id)")
        return apiService.request(url, type: Event.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
