import Combine
import Foundation

/// ViewModel to manage the state and logic for the EventDetailView.
class EventDetailViewModel: ObservableObject {
    @Published var event: Event?              // Holds the details of the event.
    @Published var isLoading = false         // Indicates whether the data is being loaded.
    @Published var errorMessage: String?     // Stores error messages in case of a failure.

    private let repository: EventRepositoryProtocol // Dependency to fetch event data.
    private var cancellables = Set<AnyCancellable>() // Holds Combine subscriptions to manage memory.
    private let eventID: Int                 // The ID of the event being fetched.

    /// Initializes the ViewModel with the event ID and repository.
    /// - Parameters:
    ///   - eventID: The unique identifier for the event.
    ///   - repository: The repository responsible for fetching event data (default: `EventRepository`).
    init(
        eventID: Int,
        repository: EventRepositoryProtocol = EventRepository()
    ) {
        self.eventID = eventID
        self.repository = repository
        loadEventDetails() // Automatically load event details on initialization.
    }

    /// Fetches the event details from the repository.
    func loadEventDetails() {
        isLoading = true                       // Start loading.
        errorMessage = nil                     // Clear any previous errors.

        repository.fetchEvent(by: eventID)     // Fetch event by ID.
            .receive(on: DispatchQueue.main)   // Ensure updates are on the main thread.
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false         // Stop loading regardless of the outcome.
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription // Store error message.
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] event in
                self?.event = event            // Update the event data.
            })
            .store(in: &cancellables)          // Store the subscription.
    }

    /// Generates content for sharing the event details.
    /// - Returns: An array of shareable content, defaulting to a fallback message if the event is unavailable.
    func generateShareContent() -> [Any] {
        guard let event = event else { return ["Check out this event!"] }
        let shareText = """
        \(event.title)
        Location: \(event.venueAddress ?? "Somewhere")
        Details: \(event.summary)
        """
        return [shareText]
    }

    /// Generates a URL for Apple Maps with the event's location.
    /// - Returns: A URL that opens Apple Maps, or `nil` if the location is unavailable.
    func appleMapsURL() -> URL? {
        guard let location = event?.venueAddress else { return nil }
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "maps://?q=\(encodedLocation)")
    }

    /// Generates a URL for Google Maps with the event's location.
    /// - Returns: A URL that opens Google Maps, or `nil` if the location is unavailable.
    func googleMapsURL() -> URL? {
        guard let location = event?.venueAddress else { return nil }
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "comgooglemaps://?q=\(encodedLocation)")
    }
}
