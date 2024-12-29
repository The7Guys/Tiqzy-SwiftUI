import SwiftUI

struct HelpView: View {
    @StateObject private var viewModel = HelpViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Frequently Asked Questions Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Frequently Asked Questions")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(Constants.Design.primaryColor)

                    ForEach(viewModel.faqs.indices, id: \.self) { index in
                        FAQItem(
                            question: viewModel.faqs[index].question,
                            answer: viewModel.faqs[index].answer,
                            isExpanded: $viewModel.faqs[index].isExpanded
                        )
                    }
                }

                Divider()

                // Contact Us Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Us")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(Constants.Design.primaryColor)

                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Constants.Design.primaryColor)
                        Text("support@tiqzy.com")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Constants.Design.primaryColor)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Constants.Design.primaryColor)
                        Text("+1 (800) 123-4567")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Constants.Design.primaryColor)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Help")
    }
}

