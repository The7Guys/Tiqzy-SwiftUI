import SwiftUI

struct ContentView: View {
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

            RegisterView()
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
