import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false // Indicates if login is successful

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared

    func logIn() {
        guard validateInput() else { return }
        isLoading = true
        errorMessage = nil

        let loginRequest = LoginRequest(email: email, password: password)
        apiService.login(request: loginRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                // Save token using TokenManager
                TokenManager.shared.saveToken(response.token)
                self.isLoggedIn = true // Indicate login success
                print("Logged in successfully. Token:", response.token)
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
        // Handle Apple Login (future implementation)
    }

    func logInWithGoogle() {
        // Handle Google Login (future implementation)
    }
}
