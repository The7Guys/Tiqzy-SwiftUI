import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false // Indicates if login is successful

    func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        Task {
            do{
                let returnedUserData = try await AuthManager.shared.signIn(email: email, password: password)
                print("Successfully created user: \(returnedUserData)")
            } catch {
                print("Error creating user: \(error.localizedDescription)")
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
