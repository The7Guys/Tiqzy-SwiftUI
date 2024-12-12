import Foundation

class HelpViewModel: ObservableObject {
    @Published var faqs: [FAQItemModel] = []

    private let repository: FAQRepositoryProtocol

    init(repository: FAQRepositoryProtocol = FAQRepository()) {
        self.repository = repository
        loadFAQs()
    }

    private func loadFAQs() {
        faqs = repository.fetchFAQs()
    }

    // Toggle the expanded state of an FAQ item
    func toggleFAQExpanded(for faq: FAQItemModel) {
        if let index = faqs.firstIndex(where: { $0.id == faq.id }) {
            faqs[index].isExpanded.toggle()
        }
    }
}
