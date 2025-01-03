import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedLocation: String = "Anywhere"
    @Published var selectedDate: String = "Anytime"
    @Published var notificationsCount: Int = 2
    @Published var cities: [City] = [
        .amsterdam,
        .haarlem,
        .rotterdam,
        .theHague,
        .breda,
        .delft,
        .eindhoven,
        .leiden]
    @Published var categories: [Category] = [
        .museums,
        .art,
        .foodAndDrink,
        .outdoor,
        .historical,
        .sports,
        .festivals,
        .networking]

    func performSearch() {
        // Logic for handling search (e.g., updating state, API call, etc.)
        print("Performing search for \(selectedLocation) on \(selectedDate)")
    }
}
