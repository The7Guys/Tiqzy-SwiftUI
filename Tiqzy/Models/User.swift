import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let user: User
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let success: Bool
    let message: String
    let token: String
}
