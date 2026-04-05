import Foundation
import XCTest
@testable import LetIt

final class JobTests: XCTestCase {
    func testCreateAndDeleteJob() async throws {
        let client = try LiveTestConfig.makeClient()
        let id = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        let logoBytes = try loadLogoBytes()

        let request = CreateJobWithCompanyRequest(
            companyName: "Acme \(id.prefix(8))",
            companyDescription: "Remote-first company.",
            companyWebsite: "https://example.com",
            jobTitle: "Senior Swift Developer \(id.prefix(6))",
            jobDescription: "Build SDKs and APIs.",
            jobHowToApply: "https://example.com/apply",
            companyLogo: FilePayload(filename: "logo.png", bytes: logoBytes, mimeType: "image/png"),
            jobLocation: .remote
        )

        let created = try await client.job.createWithCompany(request)
        XCTAssertFalse(created.slug.isEmpty)

        try await client.job.delete(slug: created.slug)
    }

    private func loadLogoBytes() throws -> Data {
        let fileURL = URL(fileURLWithPath: #filePath)
        let repoRoot = fileURL
            .deletingLastPathComponent() // LetItTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // repository root

        let logoURL = repoRoot.appendingPathComponent(".github/logo.png")
        guard FileManager.default.fileExists(atPath: logoURL.path) else {
            throw XCTSkip("Logo file not found at .github/logo.png.")
        }

        return try Data(contentsOf: logoURL)
    }
}
