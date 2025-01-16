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
    
    func register() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        Task {
            do{
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                print("Successfully created user: \(returnedUserData)")
            } catch {
                print("Error creating user: \(error.localizedDescription)")
            }
        }
        
    }
}
