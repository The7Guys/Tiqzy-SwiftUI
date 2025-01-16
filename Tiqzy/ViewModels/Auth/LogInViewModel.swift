import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false // Indicates if login is successful

    func logIn() {
        guard validateInput() else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let returnedUserData = try await AuthManager.shared.signIn(email: email, password: password)
                print("Successfully logged in user: \(returnedUserData)")
                await MainActor.run {
                    self.isLoggedIn = true // Mark as logged in
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error logging in: \(error.localizedDescription)"
                    self.isLoggedIn = false
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

    private func validateInput() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Both email and password are required."
            return false
        }
        if !email.contains("@") {
            errorMessage = "Please enter a valid email address."
            return false
        }
        return true
    }
}
