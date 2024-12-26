import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedLocation: String = "Current location"
    @Published var selectedDate: String = "Today, 15 Oct"
    @Published var notificationsCount: Int = 2
    @Published var cities: [String] = ["Amsterdam", "Rotterdam", "Eindhoven", "Utrecht"]
    @Published var categories: [String] = ["Museums", "Tours", "Events", "Activities"]

    func performSearch() {
        // Logic for handling search (e.g., updating state, API call, etc.)
        print("Performing search for \(selectedLocation) on \(selectedDate)")
    }
}
