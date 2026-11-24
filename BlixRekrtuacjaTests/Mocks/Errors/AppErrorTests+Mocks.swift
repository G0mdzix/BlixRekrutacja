@testable import BlixRekrtuacja
import Foundation

extension AppErrorTests {
    struct Scenario {
        let error: any Error & Sendable
        let expectedError: AppError?
    }

    static let mappings: [Scenario] = [
        Scenario(error: APIError.status(400), expectedError: .badRequest),
        Scenario(error: APIError.status(401), expectedError: .unauthorized),
        Scenario(error: APIError.status(403), expectedError: .forbidden),
        Scenario(error: APIError.status(404), expectedError: .notFound),
        Scenario(error: APIError.status(408), expectedError: .timeout),
        Scenario(error: APIError.status(429), expectedError: .tooManyRequests),
        Scenario(error: APIError.status(500), expectedError: .server),
        Scenario(error: APIError.status(503), expectedError: .server),
        Scenario(error: APIError.status(418), expectedError: .unknown),
        Scenario(error: APIError.transport(.notConnectedToInternet), expectedError: .offline),
        Scenario(error: APIError.transport(.timedOut), expectedError: .timeout),
        Scenario(error: APIError.transport(.cannotConnectToHost), expectedError: .server),
        Scenario(error: APIError.decoding, expectedError: .decoding),
        Scenario(error: URLError(.networkConnectionLost), expectedError: .offline),
        Scenario(error: AppError.notFound, expectedError: .notFound),
        Scenario(error: CocoaError(.fileWriteNoPermission), expectedError: .unknown),
        Scenario(error: APIError.cancelled, expectedError: nil),
        Scenario(error: URLError(.cancelled), expectedError: nil),
        Scenario(error: CancellationError(), expectedError: nil)
    ]
}
