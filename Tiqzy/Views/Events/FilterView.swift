import SwiftUI

struct FilterView: View {
    @Binding var selectedCategories: Set<Category>
    @Environment(\.dismiss) private var dismiss

    let categories: [Category]
    var applyFilterAction: ((Set<Category>) -> Void) // Callback to apply filters

    var body: some View {
        NavigationStack {
            VStack {
                Text("Filter by Category")
                    .font(.custom("Poppins-SemiBold", size: 24))
                    .foregroundColor(Constants.Design.primaryColor)
                    .padding(.top)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                toggleCategory(category)
                            }) {
                                HStack {
                                    Text(category.description)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(.primary)
                                    Spacer()
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

    private func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    private func applyFilters() {
        applyFilterAction(selectedCategories) // Pass selected categories back to the view model
        dismiss()
    }
}
