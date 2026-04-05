import Foundation
import XCTest
@testable import LetIt

final class MicropostTests: XCTestCase {
    func testCreateAndDeleteMicropost() async throws {
        let client = try LiveTestConfig.makeClient()
        let id = UUID().uuidString
        let created = try await client.micropost.create(
            CreateMicropostRequest(
                body: "Live SDK test \(id)",
                title: "SDK Integration \(id.prefix(8))"
            )
        )

        XCTAssertFalse(created.publicId.isEmpty)
        XCTAssertTrue(created.link.hasPrefix("http"))

        try await client.micropost.delete(publicId: created.publicId)
    }
}
