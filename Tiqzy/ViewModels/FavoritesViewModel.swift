import Foundation

class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [Event] = []

    private let favoritesKey = "favorites"

    init() {
        loadFavorites()
    }

    // Toggle favorite
    func toggleFavorite(_ event: Event) {
        if isFavorite(event) {
            removeFavorite(event)
        } else {
            addFavorite(event)
        }
    }

    // Check if event is a favorite
    func isFavorite(_ event: Event) -> Bool {
        favorites.contains(where: { $0.id == event.id })
    }

    private func addFavorite(_ event: Event) {
        favorites.append(event)
        saveFavorites()
    }

    private func removeFavorite(_ event: Event) {
        favorites.removeAll(where: { $0.id == event.id })
        saveFavorites()
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let savedFavorites = try? JSONDecoder().decode([Event].self, from: data) {
            favorites = savedFavorites
        }
    }
}
