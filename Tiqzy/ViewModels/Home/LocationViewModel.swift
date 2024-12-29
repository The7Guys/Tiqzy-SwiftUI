import Foundation
import Combine
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchQuery: String = ""
    @Published var filteredCities: [City] = []
    @Published var currentLocation: String = "Fetching location..."

    private let allCities = City.allCases
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()

    var isSearchQueryEmpty: Bool {
        searchQuery.isEmpty && filteredCities.isEmpty
    }

    override init() {
        super.init()

        // Request location permissions
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        // Dynamically filter cities as the user types
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterCities(query: query)
            }
            .store(in: &cancellables)
    }

    func fetchCurrentLocation() {
        locationManager.startUpdatingLocation()
    }

    private func filterCities(query: String) {
        if query.isEmpty {
            filteredCities = []
        } else {
            filteredCities = allCities.filter { $0.description.lowercased().contains(query.lowercased()) }
        }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Reverse geocode to get the city name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first, let locality = placemark.locality, let adminArea = placemark.administrativeArea {
                self.currentLocation = "\(locality), \(adminArea)"
            } else {
                self.currentLocation = "Unable to determine location"
            }
        }

        // Stop updating to save battery
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation = "Unable to fetch location"
        print("Location error: \(error.localizedDescription)")
    }
}
