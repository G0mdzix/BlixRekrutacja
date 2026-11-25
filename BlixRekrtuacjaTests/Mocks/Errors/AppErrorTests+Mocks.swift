@testable import BlixRekrtuacja
import Foundation

extension AppErrorTests {
    struct Scenario {
        let error: any Error & Sendable
        let expectedError: AppError?
    }

    static let mappings: [Scenario] = [
        Scenario(error: AppError.notFound, expectedError: .notFound),
        Scenario(error: AppErrorConvertibleStub(appError: .notFound), expectedError: .notFound),
        Scenario(error: AppErrorConvertibleStub(appError: nil), expectedError: nil),
        Scenario(error: CancellationError(), expectedError: nil),
        Scenario(error: CocoaError(.fileWriteNoPermission), expectedError: .unknown)
    ]
}
