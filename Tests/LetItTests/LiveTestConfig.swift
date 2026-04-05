import Foundation
import XCTest
@testable import LetIt

enum LiveTestConfig {
    static let baseURL = "https://api.letit.com"

    static func makeClient() throws -> LetIt.Client {
        let env = ProcessInfo.processInfo.environment
        let apiToken = env["LETIT_API_TOKEN"]

        guard let apiToken, !apiToken.isEmpty else {
            throw XCTSkip("Set LETIT_API_TOKEN to run live API integration tests.")
        }

        return LetIt.Client(baseURL: baseURL, apiKey: apiToken)
    }
}