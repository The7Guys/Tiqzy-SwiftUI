//
//  AuthManager.swift
//  Tiqzy
//
//  Created by Andrei on 16/01/2025.
//
import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let name: String?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
    }
}

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    func createUser(email: String, password: String, name: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Set the user's display name
            let changeRequest = authDataResult.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            return AuthDataResultModel(user: authDataResult.user)
        }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }

}
