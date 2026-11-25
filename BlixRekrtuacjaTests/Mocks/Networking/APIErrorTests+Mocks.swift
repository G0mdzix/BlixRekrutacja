@testable import BlixRekrtuacja
import Foundation

extension APIErrorTests {
    struct Scenario {
        let error: APIError
        let expectedError: AppError?
    }

    static let mappings: [Scenario] = [
        Scenario(error: .status(400), expectedError: .unknown),
        Scenario(error: .status(401), expectedError: .invalidAPIKey),
        Scenario(error: .status(403), expectedError: .invalidAPIKey),
        Scenario(error: .status(404), expectedError: .unknown),
        Scenario(error: .status(408), expectedError: .timeout),
        Scenario(error: .status(418), expectedError: .unknown),
        Scenario(error: .status(429), expectedError: .tooManyRequests),
        Scenario(error: .status(499), expectedError: .unknown),
        Scenario(error: .status(500), expectedError: .server),
        Scenario(error: .status(503), expectedError: .server),
        Scenario(error: .status(599), expectedError: .server),
        Scenario(error: .status(600), expectedError: .unknown),
        Scenario(error: .transport(.notConnectedToInternet), expectedError: .offline),
        Scenario(error: .transport(.networkConnectionLost), expectedError: .offline),
        Scenario(error: .transport(.timedOut), expectedError: .timeout),
        Scenario(error: .transport(.cannotConnectToHost), expectedError: .server),
        Scenario(error: .transport(.badURL), expectedError: .unknown),
        Scenario(error: .decoding, expectedError: .server),
        Scenario(error: .invalidResponse, expectedError: .unknown),
        Scenario(error: .cancelled, expectedError: nil)
    ]
}
