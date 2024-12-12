import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidJSON
    case decodingError
    case uknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid"
        case .invalidResponse:
            return "The server response was invalid"
        case .invalidData:
            return "The data received from the server was invalid"
        case .invalidJSON:
            return "The JSON structure was not as expected"
        case .decodingError:
            return "Failed to decode the response"
        case .uknownError:
            return "An unknown error occured"
        }
    }
}

