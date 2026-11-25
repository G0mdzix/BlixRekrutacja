@testable import BlixRekrtuacja
import Foundation

extension BusinessDaysTests {
    struct Scenario {
        let date: Date
        let expected: Date
    }

    static let previousDays: [Scenario] = [
        Scenario(date: Date(iso: "2026-11-24T10:00:00Z"), expected: Date(iso: "2026-11-23T00:00:00Z")),
        Scenario(date: Date(iso: "2026-11-23T10:00:00Z"), expected: Date(iso: "2026-11-20T00:00:00Z")),
        Scenario(date: Date(iso: "2026-11-21T10:00:00Z"), expected: Date(iso: "2026-11-20T00:00:00Z")),
        Scenario(date: Date(iso: "2026-11-22T10:00:00Z"), expected: Date(iso: "2026-11-20T00:00:00Z")),
        Scenario(date: Date(iso: "2026-11-23T00:30:00+01:00"), expected: Date(iso: "2026-11-20T00:00:00Z")),
        Scenario(date: Date(iso: "2026-12-01T00:00:00Z"), expected: Date(iso: "2026-11-30T00:00:00Z"))
    ]

    static let dayStarts: [Scenario] = [
        Scenario(date: Date(iso: "2026-11-25T23:59:59Z"), expected: Date(iso: "2026-11-25T00:00:00Z")),
        Scenario(date: Date(iso: "2026-11-25T00:30:00+01:00"), expected: Date(iso: "2026-11-24T00:00:00Z"))
    ]
}
