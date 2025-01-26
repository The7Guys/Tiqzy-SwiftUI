import Foundation

/// ViewModel for managing the data and logic of the HelpView.
class HelpViewModel: ObservableObject {
    /// The list of FAQ items to display in the view.
    @Published var faqs: [FAQItemModel] = []

    /// The repository that provides FAQ data.
    private let repository: FAQRepositoryProtocol

    /// Initializes the HelpViewModel with an optional repository.
    /// - Parameter repository: The data source for FAQs, defaulting to `FAQRepository`.
    init(repository: FAQRepositoryProtocol = FAQRepository()) {
        self.repository = repository
        loadFAQs() // Load FAQs on initialization
    }

    /// Loads the FAQs from the repository and updates the `faqs` property.
    private func loadFAQs() {
        faqs = repository.fetchFAQs()
    }

    /// Toggles the expanded state of a given FAQ item.
    /// - Parameter faq: The FAQ item to toggle.
    func toggleFAQExpanded(for faq: FAQItemModel) {
        if let index = faqs.firstIndex(where: { $0.id == faq.id }) {
            faqs[index].isExpanded.toggle()
        }
    }
}
