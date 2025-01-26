import SwiftUI
import Combine

/// ViewModel for managing the list of events, including filtering, sorting, and fetching data.
class EventListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var events: [Event] = []          // List of all events to display
    @Published var isLoading = false             // Tracks loading state for the UI
    @Published var errorMessage: String?         // Tracks error messages to display in the UI
    @Published var selectedLocation: String      // The currently selected location filter
    @Published var selectedDate: String          // The currently selected date filter
    @Published var sortOption: EventSortOption = .dateAscending // The selected sorting option
    @Published var selectedCategories: Set<Category> = [] // The currently selected categories filter

    // MARK: - Dependencies
    private let repository: EventRepositoryProtocol // Repository for fetching events
    private var cancellables = Set<AnyCancellable>() // Stores Combine subscriptions to avoid memory leaks

    // MARK: - Initializer
    /// Initializes the ViewModel with default filters and a repository for fetching data.
    /// - Parameters:
    ///   - selectedLocation: Initial location filter.
    ///   - selectedDate: Initial date filter.
    ///   - repository: Dependency for fetching events (default is `EventRepository`).
    init(selectedLocation: String, selectedDate: String, repository: EventRepositoryProtocol = EventRepository()) {
        self.selectedLocation = selectedLocation
        self.selectedDate = selectedDate
        self.repository = repository
    }

    // MARK: - Fetch Events
    /// Fetches events from the repository based on the current filters.
    func fetchEvents() {
        isLoading = true // Start the loading state
        errorMessage = nil // Clear previous errors

        // Convert filters into query-friendly formats
        let locationFilter = selectedLocation == "Anywhere" ? "" : selectedLocation
        let dateFilter = selectedDate == "Anytime" ? "" : selectedDate
        let categoriesFilter = selectedCategories.map { $0.rawValue }.joined(separator: ",")

        // Fetch events from the repository
        repository.fetchEvents(location: locationFilter, date: dateFilter, sort: sortOption.apiValue, categories: categoriesFilter)
            .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false // Stop the loading state
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription // Handle errors
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] events in
                self?.events = events // Update the events list on success
            })
            .store(in: &cancellables) // Store the subscription to avoid memory leaks
    }

    // MARK: - Update Filters
    /// Updates the selected location filter and refetches events.
    /// - Parameter location: The new location to filter by.
    func updateLocation(_ location: String) {
        selectedLocation = location
        fetchEvents() // Refetch events with the updated filter
    }

    /// Updates the selected date filter and refetches events.
    /// - Parameter date: The new date to filter by.
    func updateDate(_ date: String) {
        selectedDate = date
        fetchEvents() // Refetch events with the updated filter
    }

    /// Updates the selected categories filter and refetches events.
    /// - Parameter categories: The new set of categories to filter by.
    func updateCategories(_ categories: Set<Category>) {
        selectedCategories = categories
        fetchEvents() // Refetch events with the updated filter
    }
}
