import Foundation
import Combine

class APIService {
    static let shared = APIService() // Singleton instance
    private init() {}

    func request<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                // Check for a valid HTTP response
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }

                // Ensure data is not empty
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
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse, NetworkError> {
            let url = URL(string: "https://api.example.com/login")! // Replace with your actual endpoint
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(request)

            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { output in
                    // Check for a valid HTTP response
                    guard let response = output.response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode) else {
                        throw NetworkError.invalidResponse
                    }

                    // Ensure data is not empty
                    guard !output.data.isEmpty else {
                        throw NetworkError.invalidData
                    }

                    return output.data
                }
                .decode(type: LoginResponse.self, decoder: JSONDecoder())
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
    
    func register(request: RegisterRequest) -> AnyPublisher<RegisterResponse, NetworkError> {
        let url = URL(string: "https://api.example.com/register")! // Replace with your actual endpoint
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                // Check for a valid HTTP response
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw NetworkError.invalidResponse
                }

                // Ensure data is not empty
                guard !output.data.isEmpty else {
                    throw NetworkError.invalidData
                }

                return output.data
            }
            .decode(type: RegisterResponse.self, decoder: JSONDecoder())
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

