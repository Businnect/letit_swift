import Foundation

public enum LetItError: Error, LocalizedError {
    case invalidURL(String)
    case transport(Error)
    case api(String)
    case decoding(Error)

    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "invalid URL: \(url)"
        case let .transport(error):
            return "request failed: \(error.localizedDescription)"
        case let .api(message):
            return "api error: \(message)"
        case let .decoding(error):
            return "decoding error: \(error.localizedDescription)"
        }
    }
}
