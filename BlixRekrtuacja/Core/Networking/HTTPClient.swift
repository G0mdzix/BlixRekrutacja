protocol HTTPClient: Sendable {
    func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response
}
