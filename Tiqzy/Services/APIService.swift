import Foundation
import Combine

/// A service for handling API requests using Combine.
class APIService {
    /// Base URL for the API.
    private let baseURL = "https://api.tiqzyapi.nl"
    
    /// Singleton instance for global access.
    static let shared = APIService()
    
    /// Private initializer to prevent external instantiation.
    private init() {}

    /// Constructs the full URL for a given path.
    /// - Parameter path: The API endpoint path.
    /// - Returns: A `URL` object.
    private func endpoint(_ path: String) -> URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    // MARK: - GET Request
    /// Makes a GET request and decodes the response into the specified type.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - type: The expected `Decodable` type of the response.
    /// - Returns: A publisher that emits the decoded response or a `NetworkError`.
    func request<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, NetworkError> {
        let urlRequest = URLRequest(url: url)

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
                    return NetworkError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - POST Request
    /// Makes a POST request with a request body and decodes the response into the specified type.
    /// - Parameters:
    ///   - path: The API endpoint path.
    ///   - body: The request body conforming to `Codable`.
    ///   - responseType: The expected `Decodable` type of the response.
    /// - Returns: A publisher that emits the decoded response or a `NetworkError`.
    func post<T: Codable, R: Decodable>(path: String, body: T, responseType: R.Type) -> AnyPublisher<R, NetworkError> {
        let url = endpoint(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        urlRequest.timeoutInterval = 10

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .retry(2) // Retry the request up to 2 times on failure
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
                    return NetworkError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }
}
