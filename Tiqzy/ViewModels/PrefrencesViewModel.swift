import Foundation
import SwiftUI

class PreferencesViewModel: ObservableObject {
    @Published var selectedCategories: Set<Category> = []

    func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    func isSelected(_ category: Category) -> Bool {
        selectedCategories.contains(category)
    }
}
