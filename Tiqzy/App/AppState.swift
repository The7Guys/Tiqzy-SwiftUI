import SwiftUI

/// Manages global app state, such as tracking new tickets.
class AppState: ObservableObject {
    /// Shared instance for accessing app state throughout the app.
    static let shared = AppState()
    
    /// Number of newly added tickets, used to update views reactively.
    @Published var newTicketCount: Int = 0
}
