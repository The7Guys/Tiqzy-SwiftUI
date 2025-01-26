import SwiftUI

/// A view representing a single FAQ item with a question and an expandable answer.
struct FAQItem: View {
    /// The question to be displayed in the FAQ item.
    let question: String
    
    /// The answer corresponding to the question.
    let answer: String
    
    /// A binding that tracks whether the answer is expanded or collapsed.
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Button to toggle the expansion state.
            Button(action: {
                withAnimation {
                    isExpanded.toggle() // Animate the toggle of the expansion state.
                }
            }) {
                HStack {
                    // Display the question.
                    Text(question)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(Constants.Design.primaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Chevron icon that changes based on the expansion state.
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Constants.Design.primaryColor)
                }
            }

            // Show the answer if the item is expanded.
            if isExpanded {
                Text(answer)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .transition(.opacity) // Smooth fade-in animation for the answer.
            }
        }
    }
}
