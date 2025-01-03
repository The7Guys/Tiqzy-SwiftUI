import SwiftUI

struct SortOptionsView: View {
    @Binding var selectedOption: EventSortOption
    var onSortChanged: () -> Void

    var body: some View {
        VStack {
            Text("Sort by")
                .font(.custom("Poppins-SemiBold", size: 20))
                .padding()

            ForEach(EventSortOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                    onSortChanged()
                }) {
                    HStack {
                        Text(option.rawValue)
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(Constants.Design.primaryColor)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
    }
}

enum EventSortOption: String, CaseIterable {
    case priceAscending = "Price: Low to High"
    case priceDescending = "Price: High to Low"
    case dateAscending = "Date: Earliest First"
    case dateDescending = "Date: Latest First"

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
