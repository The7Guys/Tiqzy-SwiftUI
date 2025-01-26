import SwiftUI

/// A view that allows users to select their preferences (categories).
/// Users can choose categories and either skip or complete the setup process.
struct PreferencesView: View {
    @StateObject private var viewModel = PreferencesViewModel() // ViewModel to manage the preferences state
    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view

    let onComplete: () -> Void // Callback to signal that the preferences process is complete
    var showBottomButtons: Bool = true // Controls the visibility of the bottom buttons (Skip & Let’s Go!)

    let categories: [Category] = Category.allCases // All available categories

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Title Section
            Text("Tell us what you like.")
                .font(.custom("Poppins-SemiBold", size: 24))
                .foregroundColor(Constants.Design.primaryColor)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            // MARK: - Categories Grid
            ScrollView {
                FlowLayout(categories) { category in
                    Button(action: {
                        viewModel.toggleCategory(category) // Toggle the selection state of the category
                    }) {
                        Text(category.description) // Display the category name
                            .font(.custom("Poppins-Regular", size: 14))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(viewModel.isSelected(category) ? Constants.Design.secondaryColor : .clear)
                            .foregroundColor(viewModel.isSelected(category) ? .white : Constants.Design.secondaryColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Constants.Design.secondaryColor, lineWidth: 2)
                            )
                            .cornerRadius(8) // Rounded corners for the button
                    }
                }
                .padding(.horizontal) // Horizontal padding around the grid
            }

            Spacer() // Pushes the buttons to the bottom of the screen

            // MARK: - Bottom Buttons
            if showBottomButtons {
                HStack(spacing: 20) {
                    // Skip Button
                    Button(action: {
                        onComplete() // Trigger completion without saving preferences
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
                        savePreferencesAndNavigate() // Save preferences and proceed
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
                .padding(.horizontal) // Horizontal padding for the button stack
            }
        }
        .padding(.bottom, 20) // Bottom padding for spacing
    }

    // MARK: - Save Preferences and Navigate
    /// Saves the selected preferences and triggers the completion callback.
    private func savePreferencesAndNavigate() {
        print("Selected Categories: \(viewModel.selectedCategories)") // Debug: Print selected categories
        onComplete() // Notify that the preferences process is complete
    }
}
