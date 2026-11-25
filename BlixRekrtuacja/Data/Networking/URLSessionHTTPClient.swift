import Foundation
import OSLog

struct URLSessionHTTPClient: HTTPClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(baseURL: URL, session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response {
        do {
            let (data, response) = try await load(makeRequest(for: endpoint))
            try validate(response)
            return try decode(Response.self, from: data)
        } catch {
            log(error, for: endpoint)
            throw error
        }
    }

    private func makeRequest<Response>(for endpoint: Endpoint<Response>) -> URLRequest {
        var url = baseURL.appending(path: endpoint.path)
        if !endpoint.query.isEmpty { url.append(queryItems: endpoint.query) }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(Header.applicationJSON, forHTTPHeaderField: Header.accept)
        if let body = endpoint.body {
            request.httpBody = body
            request.setValue(Header.applicationJSON, forHTTPHeaderField: Header.contentType)
        }
        return request
    }

    private func load(_ request: URLRequest) async throws(APIError) -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch let error as URLError {
            throw APIError(error)
        } catch {
            throw error is CancellationError ? .cancelled : .transport(.unknown)
        }
    }

    private func validate(_ response: URLResponse) throws(APIError) {
        guard let response = response as? HTTPURLResponse else { throw .invalidResponse }
        guard 200..<300 ~= response.statusCode else { throw .status(response.statusCode) }
    }

    private func decode<Response: Decodable>(_ type: Response.Type, from data: Data) throws(APIError) -> Response {
        if let empty = EmptyResponse() as? Response { return empty }
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw .decoding
        }
    }

    private func log<Response>(_ error: APIError, for endpoint: Endpoint<Response>) {
        guard error != .cancelled else { return }
        let request = "\(endpoint.method.rawValue) \(endpoint.path)"
        Logger.network.error("\(request) failed: \(String(describing: error), privacy: .public)")
    }
}

// MARK: - Constants

private extension URLSessionHTTPClient {
    enum Header {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let applicationJSON = "application/json"
    }
}
