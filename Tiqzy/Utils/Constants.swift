import SwiftUI

/// A collection of app-wide constants for configuration, design, and user preferences.
struct Constants {
    
    // MARK: - UserDefaults Keys
    /// Keys used for saving and retrieving data from `UserDefaults`.
    struct UserDefaultsKeys {
        static let favoriteEventIDs = "favoriteEventIDs" // Key for storing favorite event IDs.
        static let isLoggedIn = "isLoggedIn"            // Key for storing login status.
        static let userToken = "userToken"              // Key for storing the user's token.
    }
    
    // MARK: - Design
    /// Design-related constants for colors, spacing, and styling.
    struct Design {
        static let primaryColor = Color(hex: "1A2B48")   // Primary color used in the app.
        static let secondaryColor = Color(hex: "5677AF") // Secondary color used in the app.
        static let backgroundColor = Color(hex: "EEF5FF")// Background color used across the app.
        static let accentColor = Color.orange           // Accent color for highlights.
        static let cornerRadius: CGFloat = 12           // Default corner radius for UI elements.
        static let shadowRadius: CGFloat = 6            // Default shadow radius for UI elements.
        static let padding: CGFloat = 16                // Default padding for layout spacing.
        
        /// Applies custom styling to the `UITabBar`.
        static func applyCustomTabBarStyling() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // Set the TabBar background color.
            appearance.backgroundColor = UIColor(Constants.Design.primaryColor)
            
            // Configure appearance for unselected tab items.
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                .font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ]
            
            // Configure appearance for selected tab items.
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 12, weight: .bold)
            ]
            
            // Apply the customized appearance globally to the `UITabBar`.
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
