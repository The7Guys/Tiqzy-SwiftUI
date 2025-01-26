import Foundation

/// Manages favorite events, including adding, removing, and persisting them.
class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Event] = [] // List of favorite events.

    private let favoritesKey = "favorites" // Key for storing favorites in UserDefaults.

    init() {
        loadFavorites() // Load favorites when the ViewModel is initialized.
    }

    /// Toggles an event's favorite state.
    func toggleFavorite(_ event: Event) {
        if isFavorite(event) {
            removeFavorite(event)
        } else {
            addFavorite(event)
        }
    }

    /// Checks if an event is a favorite.
    func isFavorite(_ event: Event) -> Bool {
        favorites.contains(where: { $0.id == event.id })
    }

    /// Adds an event to the favorites list.
    private func addFavorite(_ event: Event) {
        favorites.append(event)
        saveFavorites()
    }

    /// Removes an event from the favorites list.
    private func removeFavorite(_ event: Event) {
        favorites.removeAll(where: { $0.id == event.id })
        saveFavorites()
    }

    /// Saves the favorites list to UserDefaults.
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    /// Loads the favorites list from UserDefaults.
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let savedFavorites = try? JSONDecoder().decode([Event].self, from: data) {
            favorites = savedFavorites
        }
    }
}
