import SwiftUI

/// A view to filter events by category.
struct FilterView: View {
    /// The currently selected categories, bound to the parent view.
    @Binding var selectedCategories: Set<Category>
    
    /// Dismisses the filter view when called.
    @Environment(\.dismiss) private var dismiss
    
    /// A list of all available categories to filter.
    let categories: [Category]
    
    /// Callback triggered when the user applies the selected filters.
    var applyFilterAction: ((Set<Category>) -> Void)

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Title Section
                Text("Filter by Category")
                    .font(.custom("Poppins-SemiBold", size: 24))
                    .foregroundColor(Constants.Design.primaryColor)
                    .padding(.top)

                // MARK: - Category List
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(categories, id: \.self) { category in
                            // Each category is represented as a button.
                            Button(action: {
                                toggleCategory(category) // Toggle the selection state.
                            }) {
                                HStack {
                                    // Category name.
                                    Text(category.description)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(.primary)

                                    Spacer()

                                    // Show a checkmark if the category is selected, or a circle otherwise.
                                    if selectedCategories.contains(category) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Constants.Design.secondaryColor)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }

                Spacer()

                // MARK: - Apply Filters Button
                Button(action: applyFilters) {
                    Text("Apply Filters")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.Design.primaryColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Toggle Category Selection
    /// Toggles the selection state of a category.
    private func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category) // Remove if already selected.
        } else {
            selectedCategories.insert(category) // Add if not selected.
        }
    }

    // MARK: - Apply Filters Action
    /// Applies the selected filters and dismisses the view.
    private func applyFilters() {
        applyFilterAction(selectedCategories) // Notify the parent view about the selected categories.
        dismiss() // Close the filter view.
    }
}
