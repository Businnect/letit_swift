import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class MicropostResource {
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

    public func create(_ input: CreateMicropostRequest) async throws -> CreatedWithPublicIdAndLink {
        var fields: [String: String] = [
            "body": input.body,
            "post_type": input.postType.rawValue,
            "allow_comments": String(input.allowComments),
            "is_draft": String(input.isDraft)
        ]

        if let title = input.title {
            fields["title"] = title
        }

        let boundary = "letit-\(UUID().uuidString)"
        let files = input.file.map { ["file": $0] } ?? [:]
        let body = Multipart.body(fields: fields, files: files, boundary: boundary)

        let request = try LetIt.Client.makeRequest(
            baseURL: baseURL,
            path: "/api/v1/client/micropost",
            method: "POST",
            apiKey: apiKey,
            body: body,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )

        return try await LetIt.Client.send(request, session: session, decoder: decoder, decodeAs: CreatedWithPublicIdAndLink.self)
    }

    public func delete(publicId: String) async throws {
        let body = try JSONEncoder().encode(["public_id": publicId])
        let request = try LetIt.Client.makeRequest(
            baseURL: baseURL,
            path: "/api/v1/client/micropost",
            method: "DELETE",
            apiKey: apiKey,
            body: body,
            contentType: "application/json"
        )

        try await LetIt.Client.sendVoid(request, session: session, decoder: decoder)
    }
}

public struct CreateMicropostRequest {
    public var body: String
    public var title: String?
    public var postType: PostType
    public var allowComments: Bool
    public var isDraft: Bool
    public var file: FilePayload?

    public init(
        body: String,
        title: String? = nil,
        postType: PostType = .text,
        allowComments: Bool = true,
        isDraft: Bool = false,
        file: FilePayload? = nil
    ) {
        self.body = body
        self.title = title
        self.postType = postType
        self.allowComments = allowComments
        self.isDraft = isDraft
        self.file = file
    }
}
