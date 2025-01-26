import Foundation

/// Represents a single FAQ (Frequently Asked Question) item.
struct FAQItemModel: Identifiable {
    /// A unique identifier for the FAQ item.
    let id = UUID()
    
    /// The question being asked in the FAQ.
    let question: String
    
    /// The answer corresponding to the question.
    let answer: String
    
    /// Tracks whether the FAQ item is expanded to show the answer.
    var isExpanded: Bool = false
}
