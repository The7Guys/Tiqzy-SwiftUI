import Foundation
import Combine

protocol EventRepositoryProtocol {
    func fetchEvents(location: String, date: String) -> AnyPublisher<[Event], Error>
    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error>
}

class EventRepository: EventRepositoryProtocol {
    private let apiService = APIService.shared
    private let baseURL = URL(string: "http://localhost:3000/api/v1/tickets")!

    func fetchEvents(location: String, date: String) -> AnyPublisher<[Event], Error> {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "venueCity", value: location),
            URLQueryItem(name: "date", value: date)
        ]

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
