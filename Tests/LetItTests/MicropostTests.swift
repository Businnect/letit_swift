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
        XCTAssertFalse(created.link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        XCTAssertTrue(
            created.link.contains(created.publicId) || created.link.hasPrefix("http"),
            "Expected link to include publicId or be an absolute URL, got: \(created.link)"
        )

        try await client.micropost.delete(publicId: created.publicId)
    }
}
