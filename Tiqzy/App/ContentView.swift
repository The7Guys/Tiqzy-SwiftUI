import SwiftUI

/// The main content view of the app, providing a tab-based interface.
struct ContentView: View {
    /// Observes the shared `AppState` to handle global state updates.
    @ObservedObject private var appState = AppState.shared

    /// Initializes the `ContentView` and applies custom styling for the tab bar.
    init() {
        Constants.Design.applyCustomTabBarStyling()
    }

    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // Tickets Tab with a badge to show the count of new tickets
            TicketsView()
                .tabItem {
                    Label("Tickets", systemImage: "ticket")
                }
                .badge(appState.newTicketCount)

            // Favorites Tab
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
