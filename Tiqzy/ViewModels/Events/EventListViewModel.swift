import Combine
import Foundation

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []          // List of all events
    @Published var isLoading = false             // Tracks loading state
    @Published var errorMessage: String?         // Tracks error messages
    @Published var selectedLocation: String
    @Published var selectedDate: String

    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(selectedLocation: String, selectedDate: String, repository: EventRepositoryProtocol = EventRepository()) {
        self.selectedLocation = selectedLocation
        self.selectedDate = selectedDate
        self.repository = repository
    }

    // MARK: - Fetch Events
    func fetchEvents() {
        guard !selectedLocation.isEmpty, !selectedDate.isEmpty else {
            events = []
            return
        }

        isLoading = true
        errorMessage = nil

        repository.fetchEvents(location: selectedLocation, date: selectedDate)
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

    // MARK: - Update Filters
    func updateLocation(_ location: String) {
        selectedLocation = location
        fetchEvents()
    }

    func updateDate(_ date: String) {
        selectedDate = date
        fetchEvents()
    }
}
