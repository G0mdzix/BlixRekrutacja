@testable import BlixRekrtuacja
import Foundation

extension AppErrorTests {
    struct Scenario {
        let error: any Error & Sendable
        let expectedError: AppError?
    }

    static let mappings: [Scenario] = [
        Scenario(error: AppError.quotaExceeded, expectedError: .quotaExceeded),
        Scenario(error: AppErrorConvertibleStub(appError: .server), expectedError: .server),
        Scenario(error: AppErrorConvertibleStub(appError: nil), expectedError: nil),
        Scenario(error: CancellationError(), expectedError: nil),
        Scenario(error: CocoaError(.fileWriteNoPermission), expectedError: .unknown)
    ]
}
