import SwiftUI

struct FAQItem: View {
    let question: String
    let answer: String
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.custom("Poppins-SemiBold", size: 16))
                        .foregroundColor(Constants.Design.primaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Constants.Design.primaryColor)
                }
            }

            if isExpanded {
                Text(answer)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .transition(.opacity) // Simple fade-in animation
            }
        }
    }
}
