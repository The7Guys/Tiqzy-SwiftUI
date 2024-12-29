import Combine
import Foundation

class EventDetailViewModel: ObservableObject {
    @Published var event: Event?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let eventID: Int

    init(
        eventID: Int,
        repository: EventRepositoryProtocol = EventRepository()
    ) {
        self.eventID = eventID
        self.repository = repository
        loadEventDetails()
    }

    // Load Event Details
    func loadEventDetails() {
        isLoading = true
        errorMessage = nil

        repository.fetchEvent(by: eventID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] event in
                self?.event = event
            })
            .store(in: &cancellables)
    }

    // Generate share content
    func generateShareContent() -> [Any] {
        guard let event = event else { return ["Check out this event!"] }
        let shareText = "\(event.title)\nLocation: \(event.venueAddress ?? "Somewhere")\nDetails: \(event.description)"
        return [shareText]
    }

    // Generate Apple Maps URL
    func appleMapsURL() -> URL? {
        guard let location = event?.venueAddress else { return nil }
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "maps://?q=\(encodedLocation)")
    }

    // Generate Google Maps URL
    func googleMapsURL() -> URL? {
        guard let location = event?.venueAddress else { return nil }
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "comgooglemaps://?q=\(encodedLocation)")
    }
}
