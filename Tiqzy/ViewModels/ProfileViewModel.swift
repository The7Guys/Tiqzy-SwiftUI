import Foundation
import SwiftUI

struct MenuItem {
    let title: String
    let icon: String
    let destination: Destination
}

enum Destination {
    case favorites, pastOrders, payment, settings, help
}

@MainActor
class ProfileViewModel: ObservableObject {
    // Menu items to display in the view
    let menuItems: [MenuItem] = [
        MenuItem(title: "Favorites", icon: "heart", destination: .favorites),
        MenuItem(title: "Past Orders", icon: "clock", destination: .pastOrders),
        MenuItem(title: "Payment", icon: "creditcard", destination: .payment),
        MenuItem(title: "Settings", icon: "gear", destination: .settings),
        MenuItem(title: "Help & Support", icon: "questionmark.circle", destination: .help)
    ]

    // State to hold the user's name
    @Published var userName: String? = nil
    @Published var isLoggedIn: Bool = false // Tracks if the user is logged in

    init() {
        loadAuthenticatedUser()
    }

    /// Fetch the currently authenticated user's name
    func loadAuthenticatedUser() {
        do {
            let user = try AuthManager.shared.getAuthenticatedUser()
            self.userName = user.name ?? "Guest" // Show the displayName or "Guest" as a fallback
            self.isLoggedIn = true
        } catch {
            self.userName = nil
            self.isLoggedIn = false
        }
    }

    /// Log out the user
    func logOut() throws {
        try AuthManager.shared.signOut()
        self.userName = nil
        self.isLoggedIn = false
    }
}
