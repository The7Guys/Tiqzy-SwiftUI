import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var errorMessage: String? // Add this if you want to display errors

    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: EventRepositoryProtocol = EventRepository()) {
        self.repository = repository
        fetchEvents()
    }

    func fetchEvents() {
        repository.fetchEvents()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription // Handle the error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] fetchedEvents in
                self?.events = fetchedEvents
            })
            .store(in: &cancellables)
    }
}
