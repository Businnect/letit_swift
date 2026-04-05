import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum LetIt {
    public final class Client {
        public let baseURL: String
        public let apiKey: String

        public let job: JobResource
        public let micropost: MicropostResource

        private let session: URLSession
        private let decoder: JSONDecoder

        public init(
            baseURL: String,
            apiKey: String,
            session: URLSession = .shared,
            decoder: JSONDecoder = JSONDecoder()
        ) {
            self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
            self.apiKey = apiKey
            self.session = session
            self.decoder = decoder

            self.job = JobResource(baseURL: self.baseURL, apiKey: apiKey, session: session, decoder: decoder)
            self.micropost = MicropostResource(baseURL: self.baseURL, apiKey: apiKey, session: session, decoder: decoder)
        }
    }
}

extension LetIt.Client {
    static func makeRequest(
        baseURL: String,
        path: String,
        method: String,
        apiKey: String,
        body: Data? = nil,
        contentType: String? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw LetItError.invalidURL("\(baseURL)\(path)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue(apiKey, forHTTPHeaderField: "USER-API-TOKEN")
        request.setValue("LetIt-Swift-SDK/1.0", forHTTPHeaderField: "User-Agent")

        if let contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    static func send<T: Decodable>(
        _ request: URLRequest,
        session: URLSession,
        decoder: JSONDecoder,
        decodeAs type: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            try validate(response: response, data: data, decoder: decoder)

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw LetItError.decoding(error)
            }
        } catch let error as LetItError {
            throw error
        } catch {
            throw LetItError.transport(error)
        }
    }

    static func sendVoid(
        _ request: URLRequest,
        session: URLSession,
        decoder: JSONDecoder
    ) async throws {
        do {
            let (data, response) = try await session.data(for: request)
            try validate(response: response, data: data, decoder: decoder)
        } catch let error as LetItError {
            throw error
        } catch {
            throw LetItError.transport(error)
        }
    }

    private static func validate(response: URLResponse, data: Data, decoder: JSONDecoder) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LetItError.api("invalid response")
        }

        guard httpResponse.statusCode < 400 else {
            if let detail = try? decoder.decode(APIErrorPayload.self, from: data), let message = detail.detail {
                throw LetItError.api(message)
            }

            throw LetItError.api("status \(httpResponse.statusCode)")
        }
    }
}

private struct APIErrorPayload: Decodable {
    let detail: String?
}
