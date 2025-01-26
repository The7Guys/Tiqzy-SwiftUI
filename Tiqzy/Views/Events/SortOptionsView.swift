import SwiftUI

/// A view that allows the user to select a sorting option for events.
struct SortOptionsView: View {
    /// The currently selected sorting option.
    @Binding var selectedOption: EventSortOption
    /// Callback triggered when the sorting option changes.
    var onSortChanged: () -> Void

    var body: some View {
        VStack {
            // Title
            Text("Sort by")
                .font(.custom("Poppins-SemiBold", size: 20))
                .padding()

            // List of sorting options
            ForEach(EventSortOption.allCases, id: \.self) { option in
                Button(action: {
                    // Update the selected sorting option and notify the parent view.
                    selectedOption = option
                    onSortChanged()
                }) {
                    HStack {
                        // Display the sorting option's name.
                        Text(option.rawValue)
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.primary)

                        Spacer()

                        // Show a checkmark for the currently selected option.
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground)) // Background for the button.
                .cornerRadius(8) // Rounded corners for buttons.
            }

            Spacer() // Push content up.
        }
        .padding() // Add padding around the entire view.
    }
}

/// Represents sorting options for events.
enum EventSortOption: String, CaseIterable {
    case priceAscending = "Price: Low to High"
    case priceDescending = "Price: High to Low"
    case dateAscending = "Date: Earliest First"
    case dateDescending = "Date: Latest First"

    /// Maps each sorting option to its corresponding API parameter.
    var apiValue: String {
        switch self {
        case .priceAscending:
            return "price_asc"
        case .priceDescending:
            return "price_desc"
        case .dateAscending:
            return "date_asc"
        case .dateDescending:
            return "date_desc"
        }
    }
}
