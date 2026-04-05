import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class JobResource {
    private let baseURL: String
    private let apiKey: String
    private let session: URLSession
    private let decoder: JSONDecoder

    init(baseURL: String, apiKey: String, session: URLSession, decoder: JSONDecoder) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
        self.decoder = decoder
    }

    public func createWithCompany(_ input: CreateJobWithCompanyRequest) async throws -> UserJobCreatedByUser {
        var fields: [String: String] = [
            "company_name": input.companyName,
            "company_description": input.companyDescription,
            "company_website": input.companyWebsite,
            "job_title": input.jobTitle,
            "job_description": input.jobDescription,
            "job_how_to_apply": input.jobHowToApply,
            "job_pay_in_cryptocurrency": String(input.jobPayInCryptocurrency),
            "job_location": input.jobLocation.rawValue
        ]

        if let title = input.jobTitleOverride {
            fields["job_title"] = title
        }

        let boundary = "letit-\(UUID().uuidString)"
        let files = input.companyLogo.map { ["company_logo": $0] } ?? [:]
        let body = Multipart.body(fields: fields, files: files, boundary: boundary)

        let request = try LetIt.Client.makeRequest(
            baseURL: baseURL,
            path: "/api/v1/client/job",
            method: "POST",
            apiKey: apiKey,
            body: body,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )

        return try await LetIt.Client.send(request, session: session, decoder: decoder, decodeAs: UserJobCreatedByUser.self)
    }

    public func delete(slug: String) async throws {
        let body = try JSONEncoder().encode(["slug": slug])
        let request = try LetIt.Client.makeRequest(
            baseURL: baseURL,
            path: "/api/v1/client/job",
            method: "DELETE",
            apiKey: apiKey,
            body: body,
            contentType: "application/json"
        )

        try await LetIt.Client.sendVoid(request, session: session, decoder: decoder)
    }
}

public struct CreateJobWithCompanyRequest {
    public var companyName: String
    public var companyDescription: String
    public var companyWebsite: String
    public var jobTitle: String
    public var jobDescription: String
    public var jobHowToApply: String
    public var jobPayInCryptocurrency: Bool
    public var companyLogo: FilePayload?
    public var jobLocation: JobLocation

    // Optional override for parity with future APIs without breaking existing init.
    public var jobTitleOverride: String?

    public init(
        companyName: String,
        companyDescription: String,
        companyWebsite: String,
        jobTitle: String,
        jobDescription: String,
        jobHowToApply: String,
        jobPayInCryptocurrency: Bool = false,
        companyLogo: FilePayload? = nil,
        jobLocation: JobLocation = .remote,
        jobTitleOverride: String? = nil
    ) {
        self.companyName = companyName
        self.companyDescription = companyDescription
        self.companyWebsite = companyWebsite
        self.jobTitle = jobTitle
        self.jobDescription = jobDescription
        self.jobHowToApply = jobHowToApply
        self.jobPayInCryptocurrency = jobPayInCryptocurrency
        self.companyLogo = companyLogo
        self.jobLocation = jobLocation
        self.jobTitleOverride = jobTitleOverride
    }
}
