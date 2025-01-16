import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isRegistrationSuccessful: Bool = false // For navigation after successful registration

    private var cancellables = Set<AnyCancellable>()

    func register() {
        guard validateInput() else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password, name: name)
                print("Successfully created user: \(returnedUserData)")

                // Set registration as successful
                await MainActor.run {
                    self.isRegistrationSuccessful = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error creating user: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

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
