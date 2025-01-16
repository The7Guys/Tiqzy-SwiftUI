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

    // Binding for navigation
    @Published var selectedDestination: Destination? = nil // Tracks the selected menu destination
    
    func logOut() throws{
        try AuthManager.shared.signOut()
    }
}
