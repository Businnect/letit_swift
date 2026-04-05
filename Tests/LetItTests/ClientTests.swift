import Foundation
import XCTest
@testable import LetIt

final class ClientTests: XCTestCase {
    func testInvalidTokenReturnsDetailMessage() async {
        let client = LetIt.Client(baseURL: LiveTestConfig.baseURL, apiKey: "invalid-token")

        do {
            _ = try await client.micropost.create(
                CreateMicropostRequest(
                    body: "Live auth probe \(UUID().uuidString)",
                    title: "Invalid token test"
                )
            )
            XCTFail("Expected LetItError.api")
        } catch LetItError.api(let message) {
            XCTAssertFalse(message.isEmpty)
            XCTAssertTrue(message.localizedCaseInsensitiveContains("token") || message.localizedCaseInsensitiveContains("auth"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
