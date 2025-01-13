import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var newTicketCount: Int = 0
}
