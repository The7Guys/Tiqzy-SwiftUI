import Combine
import Foundation

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []          // List of all events
    @Published var isLoading = false             // Tracks loading state
    @Published var errorMessage: String?         // Tracks error messages

    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: EventRepositoryProtocol = EventRepository()) {
        self.repository = repository
        fetchEvents() // Load initial data
    }

    // MARK: - Fetch Events
    func fetchEvents() {
        isLoading = true
        errorMessage = nil

        repository.fetchEvents()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] events in
                self?.events = events
            })
            .store(in: &cancellables)
    }

    // MARK: - Event by ID
    func getEvent(by id: Int) -> Event? {
        events.first(where: { $0.id == id })
    }
}
