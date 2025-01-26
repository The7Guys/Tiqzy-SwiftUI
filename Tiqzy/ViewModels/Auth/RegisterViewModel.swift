import Combine
import Foundation

/// ViewModel for handling user registration, including input validation, asynchronous registration, and error handling.
class RegisterViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var name: String = ""                       // User's name input.
    @Published var email: String = ""                      // User's email input.
    @Published var password: String = ""                   // User's password input.
    @Published var isLoading: Bool = false                 // Indicates if a registration request is in progress.
    @Published var errorMessage: String? = nil             // Stores error messages for validation or registration failures.
    @Published var isRegistrationSuccessful: Bool = false  // Tracks whether registration was successful (used for navigation).

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()       // Stores any Combine subscriptions (if needed in the future).

    // MARK: - Public Methods
    /// Initiates the registration process.
    func register() {
        // Validate input before proceeding with registration.
        guard validateInput() else { return }

        isLoading = true          // Start loading.
        errorMessage = nil        // Clear any previous error message.

        Task {
            do {
                // Attempt to create a new user using the AuthManager.
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password, name: name)
                print("Successfully created user: \(returnedUserData)")

                // Mark registration as successful for navigation or further actions.
                await MainActor.run {
                    self.isRegistrationSuccessful = true
                }
            } catch {
                // Handle registration errors and display an error message.
                await MainActor.run {
                    self.errorMessage = "Error creating user: \(error.localizedDescription)"
                }
            }
            // Stop loading after the process completes.
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

    // MARK: - Private Methods
    /// Validates the user's input for name, email, and password.
    /// - Returns: `true` if input is valid, otherwise `false` with an appropriate error message.
    private func validateInput() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Name, email, and password are required."
            return false
        }
        if !email.contains("@") {
            errorMessage = "Please enter a valid email address."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        return true
    }
}
