import SwiftUI

struct ContentView: View {
    @ObservedObject private var appState = AppState.shared // Observe AppState
    init() {
        Constants.Design.applyCustomTabBarStyling()
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            TicketsView()
                .tabItem {
                    Label("Tickets", systemImage: "ticket")
                }
                .badge(appState.newTicketCount)
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

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
