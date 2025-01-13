import SwiftUI
import Combine

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []          // List of all events
    @Published var isLoading = false             // Tracks loading state
    @Published var errorMessage: String?         // Tracks error messages
    @Published var selectedLocation: String
    @Published var selectedDate: String
    @Published var sortOption: EventSortOption = .dateAscending
    @Published var selectedCategories: Set<Category> = [] // Use Set<Category>

    private let repository: EventRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(selectedLocation: String, selectedDate: String, repository: EventRepositoryProtocol = EventRepository()) {
        self.selectedLocation = selectedLocation
        self.selectedDate = selectedDate
        self.repository = repository
    }

    // MARK: - Fetch Events
    func fetchEvents() {
        isLoading = true
        errorMessage = nil

        let locationFilter = selectedLocation == "Anywhere" ? "" : selectedLocation
        let dateFilter = selectedDate == "Anytime" ? "" : selectedDate
        let categoriesFilter = selectedCategories.map { $0.rawValue }.joined(separator: ",")

        repository.fetchEvents(location: locationFilter, date: dateFilter, sort: sortOption.apiValue, categories: categoriesFilter)
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

    func updateCategories(_ categories: Set<Category>) {
        selectedCategories = categories
        fetchEvents()
    }
}
