import Foundation
import Combine

class LocationViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var filteredCities: [City] = []
    @Published var currentLocation: String = "Amsterdam, Noord-Holland"

    private let allCities = City.allCases
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterCities(query: query)
            }
            .store(in: &cancellables)
    }

    func fetchCurrentLocation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentLocation = "Amsterdam, Noord-Holland"
        }
    }

    private func filterCities(query: String) {
        if query.isEmpty {
            filteredCities = []
        } else {
            filteredCities = allCities.filter { $0.description.lowercased().contains(query.lowercased()) }
        }
    }

    func selectLocation(_ location: City) {
        print("Selected location: \(location.description), \(location.region)")
    }
}
