import Foundation
import FirebaseAuth

/// Represents the authenticated user's data.
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let name: String?
    
    /// Initializes the model with a `FirebaseAuth.User`.
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
    }
}

/// Handles authentication operations like sign-in, sign-up, and password reset.
final class AuthManager {
    static let shared = AuthManager() // Singleton instance
    private init() {}
    
    /// Retrieves the currently authenticated user.
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    
    /// Creates a new user with email, password, and name.
    func createUser(email: String, password: String, name: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = authDataResult.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    /// Signs in a user with email and password.
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    /// Sends a password reset email.
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    /// Signs out the current user.
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
