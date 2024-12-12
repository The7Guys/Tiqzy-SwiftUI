import Foundation
import Combine

protocol EventRepositoryProtocol {
    func fetchEvents() -> AnyPublisher<[Event], Error>
    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error>
}

class EventRepository: EventRepositoryProtocol {
    private let apiService = APIService.shared
    private let baseURL = URL(string: "http://localhost:3000/api/v1/tickets")!

    func fetchEvents() -> AnyPublisher<[Event], Error> {
        apiService.request(baseURL, type: [Event].self)
            .mapError { $0 as Error } // Map custom `NetworkError` to generic `Error`
            .eraseToAnyPublisher()
    }

    func fetchEvent(by id: Int) -> AnyPublisher<Event, Error> {
        let url = baseURL.appendingPathComponent("\(id)")
        return apiService.request(url, type: Event.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
