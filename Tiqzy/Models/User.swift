struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let user: User // Update this structure based on your API's response
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let message: String
}
