import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared

    func logIn() {
        guard validateInput() else { return }
        isLoading = true

        let loginRequest = LoginRequest(email: email, password: password)
        apiService.login(request: loginRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                // Handle successful login (e.g., save token, navigate)
                print("Logged in:", response.token)
            })
            .store(in: &cancellables)
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

    func logInWithApple() {
        // Handle Apple Login
    }

    func logInWithGoogle() {
        // Handle Google Login
    }
}
