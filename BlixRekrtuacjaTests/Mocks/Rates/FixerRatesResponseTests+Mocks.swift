@testable import BlixRekrtuacja

extension FixerRatesResponseTests {
    struct ErrorScenario {
        let body: String
        let expectedError: AppError
    }

    static let errorCodes: [ErrorScenario] = [
        ErrorScenario(body: failure(code: 101), expectedError: .invalidAPIKey),
        ErrorScenario(body: failure(code: 102), expectedError: .invalidAPIKey),
        ErrorScenario(body: failure(code: 104), expectedError: .quotaExceeded),
        ErrorScenario(body: failure(code: 106), expectedError: .tooManyRequests),
        ErrorScenario(body: failure(code: 105), expectedError: .server),
        ErrorScenario(body: #"{"success":false}"#, expectedError: .server)
    ]

    static let incompleteBodies = [
        #"{"success":true,"timestamp":1795305599,"date":"2026-11-21","rates":{}}"#,
        #"{"success":true,"base":"EUR","date":"2026-11-21","rates":{}}"#,
        #"{"success":true,"timestamp":1795305599,"base":"EUR","date":"2026-11-21"}"#,
        #"{"success":true,"timestamp":1795305599,"base":"EUR","rates":{}}"#,
        #"{"success":true,"timestamp":1795305599,"base":"EUR","date":"21.11.2026","rates":{}}"#
    ]

    private static func failure(code: Int) -> String {
        #"{"success":false,"error":{"code":\#(code),"type":"error","info":"Info"}}"#
    }
}
