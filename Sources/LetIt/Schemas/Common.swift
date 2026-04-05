import Foundation

public struct FilePayload {
    public let filename: String
    public let bytes: Data
    public let mimeType: String?

    public init(filename: String, bytes: Data, mimeType: String? = nil) {
        self.filename = filename
        self.bytes = bytes
        self.mimeType = mimeType
    }
}

public struct CreatedWithPublicIdAndLink: Decodable {
    public let publicId: String
    public let link: String

    enum CodingKeys: String, CodingKey {
        case publicId = "public_id"
        case link
    }
}
