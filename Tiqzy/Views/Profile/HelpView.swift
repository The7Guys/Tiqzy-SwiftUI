import SwiftUI

/// A view that displays frequently asked questions (FAQs) and contact information.
struct HelpView: View {
    @StateObject private var viewModel = HelpViewModel() // ViewModel to manage FAQ data

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Frequently Asked Questions Section
                VStack(alignment: .leading, spacing: 16) {
                    // Section Title
                    Text("Frequently Asked Questions")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(Constants.Design.primaryColor)

                    // FAQ List
                    ForEach(viewModel.faqs.indices, id: \.self) { index in
                        FAQItem(
                            question: viewModel.faqs[index].question, // FAQ question
                            answer: viewModel.faqs[index].answer,   // FAQ answer
                            isExpanded: $viewModel.faqs[index].isExpanded // Expansion toggle
                        )
                    }
                }

                // Divider between sections
                Divider()

                // MARK: - Contact Us Section
                VStack(alignment: .leading, spacing: 16) {
                    // Section Title
                    Text("Contact Us")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(Constants.Design.primaryColor)

                    // Email Contact
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Constants.Design.primaryColor)
                        Text("support@tiqzy.com")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Constants.Design.primaryColor)
                    }

                    // Phone Contact
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Constants.Design.primaryColor)
                        Text("+1 (800) 123-4567")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Constants.Design.primaryColor)
                    }
                }
            }
            .padding() // Padding around the entire content
        }
        .navigationTitle("Help") // Navigation title
    }
}
