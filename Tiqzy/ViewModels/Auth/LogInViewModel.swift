import Foundation
import Combine

/// ViewModel for handling login functionality, including input validation and authentication.
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""          // User's email input.
    @Published var password: String = ""       // User's password input.
    @Published var isLoading: Bool = false     // Indicates if a login request is in progress.
    @Published var errorMessage: String?       // Stores error messages for login validation or failure.
    @Published var isLoggedIn: Bool = false    // Indicates if the user is successfully logged in.

    // MARK: - Public Methods
    /// Attempts to log in the user with the provided email and password.
    /// - Parameter completion: A closure called with a `Bool` indicating success or failure.
    func logIn(completion: @escaping (Bool) -> Void) {
        // Validate input before proceeding with login.
        guard validateInput() else {
            completion(false) // Notify failure if validation fails.
            return
        }

        isLoading = true          // Start loading.
        errorMessage = nil        // Clear any previous error message.

        Task {
            do {
                // Attempt to sign in using the AuthManager.
                let returnedUserData = try await AuthManager.shared.signIn(email: email, password: password)
                print("Successfully logged in user: \(returnedUserData)")
                await MainActor.run {
                    self.isLoggedIn = true // Mark as logged in.
                    completion(true)       // Notify success.
                }
            } catch {
                await MainActor.run {
                    // Handle login error and display an error message.
                    self.errorMessage = "Error logging in: \(error.localizedDescription)"
                    self.isLoggedIn = false
                    completion(false)      // Notify failure.
                }
            }
            await MainActor.run {
                self.isLoading = false // Stop loading after the login process finishes.
            }
        }
    }

    // MARK: - Private Methods
    /// Validates the user's email and password input.
    /// - Returns: `true` if input is valid, otherwise `false` with an error message.
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
