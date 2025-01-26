import Foundation
import Combine
import CoreLocation

/// ViewModel for managing location-based functionality and dynamic city search.
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Published Properties
    @Published var searchQuery: String = "" // User's search query.
    @Published var filteredCities: [City] = [] // Cities filtered based on the search query.
    @Published var currentLocation: String = "Fetching location..." // User's current location as a string.

    // MARK: - Private Properties
    private let allCities = City.allCases // All available cities to search.
    private var cancellables = Set<AnyCancellable>() // Stores Combine subscriptions.
    private let locationManager = CLLocationManager() // Manages location updates.

    // Computed property to check if the search query is empty and no filtered results exist.
    var isSearchQueryEmpty: Bool {
        searchQuery.isEmpty && filteredCities.isEmpty
    }

    // MARK: - Initialization
    override init() {
        super.init()

        // Configure the location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Request user permissions for location.

        // Dynamically filter cities as the user types in the search query.
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main) // Debounce to avoid rapid filtering.
            .sink { [weak self] query in
                self?.filterCities(query: query)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    /// Starts fetching the user's current location.
    func fetchCurrentLocation() {
        locationManager.startUpdatingLocation()
    }

    // MARK: - Private Methods

    /// Filters the list of cities based on the user's search query.
    /// - Parameter query: The search query entered by the user.
    private func filterCities(query: String) {
        if query.isEmpty {
            filteredCities = [] // Clear filtered cities if the query is empty.
        } else {
            filteredCities = allCities.filter { $0.description.lowercased().contains(query.lowercased()) }
        }
    }

    // MARK: - CLLocationManagerDelegate Methods

    /// Called when the location manager updates the user's location.
    /// - Parameters:
    ///   - manager: The location manager providing updates.
    ///   - locations: The array of updated locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Reverse geocode the location to get a readable city name.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first, let locality = placemark.locality, let adminArea = placemark.administrativeArea {
                self.currentLocation = "\(locality), \(adminArea)" // Format the location as "City, State".
            } else {
                self.currentLocation = "Unable to determine location"
            }
        }

        // Stop updating location to save battery.
        locationManager.stopUpdatingLocation()
    }

    /// Called when the location manager fails to retrieve the location.
    /// - Parameters:
    ///   - manager: The location manager that encountered an error.
    ///   - error: The error that occurred.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation = "Unable to fetch location" // Update the location string with an error message.
        print("Location error: \(error.localizedDescription)") // Log the error for debugging.
    }
}
