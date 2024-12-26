import Foundation
import Combine

class LocationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var filteredCities: [String] = []
    @Published var currentLocation: String = "Amsterdam, Noord-Holland"
    
    private let allCities = ["Amsterdam", "Rotterdam", "Eindhoven", "The Hague", "Utrecht", "Groningen", "Leiden"]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Filter cities dynamically as the user types
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterCities(query: query)
            }
            .store(in: &cancellables)
    }
    
    func fetchCurrentLocation() {
        // Placeholder: Simulate fetching the current location
        // In real apps, integrate with CoreLocation to get the actual current location
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentLocation = "Amsterdam, Noord-Holland"
        }
    }
    
    private func filterCities(query: String) {
        if query.isEmpty {
            filteredCities = []
        } else {
            filteredCities = allCities.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
    
    func selectLocation(_ location: String) {
        print("Selected location: \(location)") // Pass the selection to the main view
    }
}
