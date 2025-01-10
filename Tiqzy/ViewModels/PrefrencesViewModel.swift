import Foundation

class PreferencesViewModel: ObservableObject {
    @Published var selectedCategories: Set<Category> = []

    private let preferencesKey = "SelectedCategories"

    init() {
        loadPreferences()
    }

    /// Check if a category is selected
    func isSelected(_ category: Category) -> Bool {
        selectedCategories.contains(category)
    }

    /// Toggle category selection
    func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        savePreferences()
    }

    /// Save preferences to UserDefaults
    private func savePreferences() {
        let descriptions = selectedCategories.map { $0.description }
        UserDefaults.standard.set(descriptions, forKey: preferencesKey)
    }

    /// Load preferences from UserDefaults
    private func loadPreferences() {
        if let descriptions = UserDefaults.standard.array(forKey: preferencesKey) as? [String] {
            let categories = descriptions.compactMap { description in
                Category.allCases.first(where: { $0.description == description })
            }
            selectedCategories = Set(categories)
        }
    }
}
