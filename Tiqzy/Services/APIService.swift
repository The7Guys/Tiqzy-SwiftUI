import Foundation
import Combine

class APIService {
    private let baseURL = "https://api.tiqzyapi.nl/auth"
    static let shared = APIService() // Singleton instance
    private init() {}

    private func endpoint(_ path: String) -> URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    private func addAuthHeader(to request: inout URLRequest) {
        if let token = TokenManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    // MARK: - GET Request
    func request<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, NetworkError> {
        var urlRequest = URLRequest(url: url)
        addAuthHeader(to: &urlRequest)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                guard !output.data.isEmpty else {
                    throw NetworkError.invalidData
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.uknownError
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - POST Request
    func post<T: Codable, R: Decodable>(path: String, body: T, responseType: R.Type, requiresAuth: Bool = false) -> AnyPublisher<R, NetworkError> {
        let url = endpoint(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        urlRequest.timeoutInterval = 10

        if requiresAuth {
            addAuthHeader(to: &urlRequest)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .retry(2)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                guard !output.data.isEmpty else {
                    throw NetworkError.invalidData
                }
                return output.data
            }
            .decode(type: R.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.uknownError
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Specific API Calls
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, NetworkError> {
        return post(path: "/login", body: request, responseType: LoginResponse.self)
    }

    func register(request: RegisterRequest) -> AnyPublisher<RegisterResponse, NetworkError> {
        return post(path: "/register", body: request, responseType: RegisterResponse.self)
    }

    func fetchProtectedResource<R: Decodable>(path: String, responseType: R.Type) -> AnyPublisher<R, NetworkError> {
        let url = endpoint(path)
        var urlRequest = URLRequest(url: url)
        addAuthHeader(to: &urlRequest)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                guard !output.data.isEmpty else {
                    throw NetworkError.invalidData
                }
                return output.data
            }
            .decode(type: R.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.uknownError
                }
            }
            .eraseToAnyPublisher()
    }
}
