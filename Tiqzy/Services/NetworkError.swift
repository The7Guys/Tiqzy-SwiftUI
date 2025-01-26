import Foundation

/// Represents common network-related errors that can occur during API calls.
enum NetworkError: Error, LocalizedError {
    case invalidURL         // The provided URL is invalid or malformed.
    case invalidResponse    // The server response is not within the expected range (e.g., 200-299).
    case invalidData        // The data received from the server is empty or corrupt.
    case invalidJSON        // The JSON structure is not in the expected format.
    case decodingError      // Failed to decode the data into the expected model.
    case unknownError       // An unspecified or unknown error occurred.

    /// Provides a human-readable description of the error.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .invalidData:
            return "The data received from the server was invalid."
        case .invalidJSON:
            return "The JSON structure was not as expected."
        case .decodingError:
            return "Failed to decode the response."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
