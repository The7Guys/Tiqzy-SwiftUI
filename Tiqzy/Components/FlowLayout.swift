import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    private let data: Data
    private let content: (Data.Element) -> Content
    private let rowSpacing: CGFloat // New parameter for vertical spacing

    @State private var totalHeight = CGFloat.zero // Height for the layout

    init(
        _ data: Data,
        rowSpacing: CGFloat = 10, // Default vertical spacing
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.rowSpacing = rowSpacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .padding(.horizontal, 6)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= (dimension.height + rowSpacing) // Add row spacing
                        }
                        let result = width
                        if item == data.last {
                            width = 0 // Reset for next row
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if item == data.last {
                            height = 0 // Reset for next row
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geometry.frame(in: .local).size.height
            }
            return Color.clear
        }
    }
}
