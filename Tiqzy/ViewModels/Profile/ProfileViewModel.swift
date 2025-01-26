import Foundation
import SwiftUI

/// Represents a menu item in the profile view.
struct MenuItem {
    let title: String // The title of the menu item
    let icon: String // The icon associated with the menu item
    let destination: Destination // The navigation destination
}

/// Enum representing the possible destinations in the profile view.
enum Destination {
    case preferences, help
}

/// ViewModel for managing the `ProfileView`.
@MainActor
class ProfileViewModel: ObservableObject {
    /// Menu items displayed in the profile view.
    let menuItems: [MenuItem] = [
        MenuItem(title: "Preferences", icon: "gear", destination: .preferences),
        MenuItem(title: "Help & Support", icon: "questionmark.circle", destination: .help)
    ]

    @Published var userName: String? = nil // The currently authenticated user's name
    @Published var isLoggedIn: Bool = false // Tracks if the user is logged in

    // MARK: - Initialization
    init() {
        loadAuthenticatedUser() // Load the user's data upon initialization
    }

    // MARK: - Load Authenticated User
    /// Fetches the currently authenticated user's information.
    func loadAuthenticatedUser() {
        do {
            let user = try AuthManager.shared.getAuthenticatedUser()
            self.userName = user.name ?? "Guest" // Fallback to "Guest" if no display name is available
            self.isLoggedIn = true
        } catch {
            self.userName = nil
            self.isLoggedIn = false
        }
    }

    // MARK: - Log Out
    /// Logs out the currently authenticated user.
    func logOut() throws {
        try AuthManager.shared.signOut()
        self.userName = nil
        self.isLoggedIn = false
    }
}
