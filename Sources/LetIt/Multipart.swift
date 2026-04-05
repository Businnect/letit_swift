import Foundation

enum Multipart {
    static func body(
        fields: [String: String],
        files: [String: FilePayload],
        boundary: String
    ) -> Data {
        var data = Data()

        for (name, value) in fields {
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            data.append("\(value)\r\n")
        }

        for (name, file) in files {
            let mimeType = file.mimeType ?? "application/octet-stream"

            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(file.filename)\"\r\n")
            data.append("Content-Type: \(mimeType)\r\n\r\n")
            data.append(file.bytes)
            data.append("\r\n")
        }

        data.append("--\(boundary)--\r\n")
        return data
    }
}

private extension Data {
    mutating func append(_ string: String) {
        self.append(contentsOf: string.utf8)
    }
}
