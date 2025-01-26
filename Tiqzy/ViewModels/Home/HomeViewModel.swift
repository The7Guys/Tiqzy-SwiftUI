import Foundation

/// ViewModel for the HomeView, managing the state and logic for location, date, notifications, cities, and categories.
class HomeViewModel: ObservableObject {
    /// The selected location for the event search (default: "Anywhere").
    @Published var selectedLocation: String = "Anywhere"
    
    /// The selected date for the event search (default: "Anytime").
    @Published var selectedDate: String = "Anytime"
    
    /// The number of notifications to display in the bell icon.
    @Published var notificationsCount: Int = 2
    
    /// List of cities to display in the "Explore Cities" section.
    @Published var cities: [City] = [
        .amsterdam,
        .haarlem,
        .rotterdam,
        .theHague,
        .breda,
        .delft,
        .eindhoven,
        .leiden
    ]
    
    /// List of categories to display in the "Explore Categories" section.
    @Published var categories: [Category] = [
        .museums,
        .art,
        .foodAndDrink,
        .outdoor,
        .historical,
        .sports,
        .festivals,
        .networking
    ]

    /// Performs a search with the currently selected location and date.
    /// - This method can be extended to make API calls or update the app's state based on the search parameters.
    func performSearch() {
        print("Performing search for \(selectedLocation) on \(selectedDate)")
    }
}
