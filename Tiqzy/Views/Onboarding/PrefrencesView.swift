import SwiftUI

struct PreferencesView: View {
    @StateObject private var viewModel = PreferencesViewModel()
    @Environment(\.dismiss) private var dismiss

    let onComplete: () -> Void // Callback to signal completion
    var showBottomButtons: Bool = true // Controls visibility of bottom buttons

    let categories: [Category] = Category.allCases

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Tell us what you like.")
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundColor(Constants.Design.primaryColor)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            // Categories Grid
            ScrollView {
                FlowLayout(categories) { category in
                    Button(action: {
                        viewModel.toggleCategory(category)
                    }) {
                        Text(category.description)
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(viewModel.isSelected(category) ? Constants.Design.secondaryColor : .clear)
                            .foregroundColor(viewModel.isSelected(category) ? .white : Constants.Design.secondaryColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Constants.Design.secondaryColor, lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // Bottom Buttons
            if showBottomButtons {
                HStack(spacing: 20) {
                    // Skip Button
                    Button(action: {
                        onComplete()
                    }) {
                        Text("Skip")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(Constants.Design.primaryColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Constants.Design.primaryColor, lineWidth: 1)
                            )
                    }

                    // Let’s Go! Button
                    Button(action: {
                        savePreferencesAndNavigate()
                    }) {
                        Text("Let’s Go!")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.primaryColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 20)
    }

    private func savePreferencesAndNavigate() {
        print("Selected Categories: \(viewModel.selectedCategories)")
        onComplete()
    }
}
