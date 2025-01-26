import Foundation

/// ViewModel for managing user preferences in the `PreferencesView`.
class PreferencesViewModel: ObservableObject {
    /// The set of currently selected categories.
    @Published var selectedCategories: Set<Category> = []

    /// Key for storing preferences in `UserDefaults`.
    private let preferencesKey = "SelectedCategories"

    /// Initializes the ViewModel and loads saved preferences.
    init() {
        loadPreferences()
    }

    /// Checks if a category is selected.
    func isSelected(_ category: Category) -> Bool {
        selectedCategories.contains(category)
    }

    /// Toggles the selection state of a category and saves the changes.
    func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        savePreferences()
    }

    /// Saves selected categories to `UserDefaults`.
    private func savePreferences() {
        let descriptions = selectedCategories.map { $0.description }
        UserDefaults.standard.set(descriptions, forKey: preferencesKey)
    }

    /// Loads saved preferences from `UserDefaults`.
    private func loadPreferences() {
        if let descriptions = UserDefaults.standard.array(forKey: preferencesKey) as? [String] {
            selectedCategories = Set(
                descriptions.compactMap { description in
                    Category.allCases.first { $0.description == description }
                }
            )
        }
    }
}
