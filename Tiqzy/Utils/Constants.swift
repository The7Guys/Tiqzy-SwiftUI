import SwiftUI

struct Constants {
    
    // MARK: - API Endpoints
    struct API {
        static let baseURL = "https://yourapi.com/api"
        static let events = "\(baseURL)/events"
        static let tickets = "\(baseURL)/tickets"
        static let favorites = "\(baseURL)/favorites"
        static let userProfile = "\(baseURL)/user"
    }
    
    // MARK: - Strings
    struct Strings {
        static let appName = "Tiqzy"
        static let loading = "Loading..."
        static let noFavoritesMessage = "You haven't favorited any events yet."
        static let noTicketsMessage = "You haven't purchased any tickets yet."
        static let errorMessage = "Something went wrong. Please try again later."
    }
    
    // MARK: - Default Values
    struct Defaults {
        static let paginationSize = 20
        static let ticketPlaceholderImage = "ticket_placeholder" // Replace with your image asset name
        static let eventPlaceholderImage = "event_placeholder"  // Replace with your image asset name
    }
    
    // MARK: - Design
    struct Design {
        static let primaryColor = Color(hex: "1A2B48")
        static let secondaryColor = Color(hex: "5677AF")
        static let backgroundColor = Color(hex: "EEF5FF")
        static let accentColor = Color.orange
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 6
        static let padding: CGFloat = 16
        
        static func applyCustomTabBarStyling() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // TabBar Background Color
            appearance.backgroundColor = UIColor(Constants.Design.primaryColor)
            
            // Unselected Tab Items (slightly transparent)
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                .font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ]
            
            // Selected Tab Items (bold and opaque)
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 12, weight: .bold)
            ]
            
            // Apply the Appearance Globally
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let favoriteEventIDs = "favoriteEventIDs"
        static let isLoggedIn = "isLoggedIn"
        static let userToken = "userToken"
    }
    
    // MARK: - Animation
    struct Animation {
        static let fadeDuration: Double = 0.25
    }
}

