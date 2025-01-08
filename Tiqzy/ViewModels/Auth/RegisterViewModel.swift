import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isRegistrationSuccessful: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Register User
    func register() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let registerRequest = RegisterRequest(name: name, email: email, password: password)
        
        APIService.shared.register(request: registerRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                print("Registration successful: \(response)")
                
                // Save token if registration is successful
                if response.success {
                    TokenManager.shared.saveToken(response.token)
                    self.isRegistrationSuccessful = true
                } else {
                    self.errorMessage = response.message
                }
            })
            .store(in: &cancellables)
    }
}
