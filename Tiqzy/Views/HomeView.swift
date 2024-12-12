import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.events) { event in
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.headline)
                    Text(event.location!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Price: $\(event.price!, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    ContentView()
}
