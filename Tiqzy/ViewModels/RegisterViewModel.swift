import Combine
import SwiftUI

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
                    self.isRegistrationSuccessful = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                print("Registration successful: \(response)")
                self?.isRegistrationSuccessful = true
            })
            .store(in: &cancellables)
    }
}
