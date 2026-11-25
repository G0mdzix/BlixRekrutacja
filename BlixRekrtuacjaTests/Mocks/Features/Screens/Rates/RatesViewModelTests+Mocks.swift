@testable import BlixRekrtuacja
import Foundation

extension RatesViewModelTests {
    struct StartScenario {
        let latestDay: Date
        let expectedDays: [Date]
    }

    struct FirstLoadScenario {
        let error: AppError
        let expectedIcon: SFSymbol
        let expectedBadge: SFSymbol?
        let offersRetry: Bool
    }

    struct OlderDayFailureScenario {
        let error: AppError
        let expectedCalls: Int
        let offersRetry: Bool
    }

    enum Outcome {
        case loads
        case fails
        case isCancelled
    }

    struct RetryScenario {
        /// The first try comes from `start()`, every later one is a retry.
        let olderDayOutcomes: [Outcome]
        let expectedDays: Int
        let expectedError: AppError?
    }

    struct ReappearScenario {
        let error: AppError?
        let expectedCalls: [RatesRequest]
    }

    struct RowScenario {
        let dayIndex: Int
        let expectedCodes: [String]
        let expectedPLNChange: Decimal?
    }

    struct HeaderScenario {
        let latestDay: Date
        let expectsTodayBadge: Bool
    }

    nonisolated static let monday = Date(iso: "2026-11-23T00:00:00Z")

    nonisolated static let starts: [StartScenario] = [
        StartScenario(latestDay: RatesSamples.wednesday, expectedDays: [RatesSamples.wednesday, RatesSamples.tuesday]),
        StartScenario(latestDay: monday, expectedDays: [monday, RatesSamples.friday])
    ]

    nonisolated static let firstLoadFailures: [FirstLoadScenario] = [
        FirstLoadScenario(error: .offline, expectedIcon: .wifiSlash, expectedBadge: nil, offersRetry: true),
        FirstLoadScenario(error: .invalidAPIKey, expectedIcon: .key, expectedBadge: .xmark, offersRetry: true),
        FirstLoadScenario(error: .missingAPIKey, expectedIcon: .key, expectedBadge: nil, offersRetry: false),
        FirstLoadScenario(error: .quotaExceeded, expectedIcon: .wifiSlash, expectedBadge: nil, offersRetry: false)
    ]

    nonisolated static let olderDayFailures: [OlderDayFailureScenario] = [
        OlderDayFailureScenario(
            error: .offline,
            expectedCalls: 3,
            offersRetry: true
        ),
        OlderDayFailureScenario(
            error: .quotaExceeded,
            expectedCalls: 2,
            offersRetry: false
        ),
        OlderDayFailureScenario(
            error: .missingAPIKey,
            expectedCalls: 2,
            offersRetry: false
        )
    ]

    nonisolated static let retries: [RetryScenario] = [
        RetryScenario(olderDayOutcomes: [.fails, .loads], expectedDays: 2, expectedError: nil),
        RetryScenario(olderDayOutcomes: [.fails, .isCancelled], expectedDays: 1, expectedError: nil)
    ]

    nonisolated static let reappearances: [ReappearScenario] = [
        ReappearScenario(error: nil, expectedCalls: [.latest, .day(RatesSamples.tuesday)]),
        ReappearScenario(error: .offline, expectedCalls: [.latest])
    ]

    nonisolated static let rowScenarios: [RowScenario] = [
        RowScenario(
            dayIndex: 0,
            expectedCodes: ["CHF", "GBP", "JPY", "PLN", "USD"],
            expectedPLNChange: Decimal(exact: "0.01")
        ),
        RowScenario(
            dayIndex: 1,
            expectedCodes: ["CHF", "GBP", "PLN", "USD"],
            expectedPLNChange: nil
        )
    ]

    nonisolated static let headers: [HeaderScenario] = [
        HeaderScenario(latestDay: RatesSamples.wednesday, expectsTodayBadge: true),
        HeaderScenario(latestDay: RatesSamples.tuesday, expectsTodayBadge: false)
    ]

    static let expectedPLNSelection = RateSelection(
        code: "PLN",
        name: Locale(identifier: "en").localizedString(forCurrencyCode: "PLN"),
        value: Decimal(exact: "4.04"),
        base: "EUR",
        day: RatesSamples.wednesday,
        change: Decimal(exact: "0.01")
    )

    nonisolated static func rates(on day: Date) -> DailyRates {
        let pln = day == RatesSamples.wednesday ? "4.04" : "4.00"
        var values = ["AUD": "1.6", "CHF": "0.92", "GBP": "0.83", "JPY": "173.9", "PLN": pln, "USD": "1.09"]
        if day != RatesSamples.wednesday { values["JPY"] = nil }
        return DailyRates(
            day: day,
            base: "EUR",
            updatedAt: day,
            rates: values.map { CurrencyRate(code: $0.key, value: Decimal(exact: $0.value)) }.sorted()
        )
    }
}

extension RatesViewModel.Content {
    var emptyState: BlixEmptyStateConfigurator? {
        guard case .failed(let emptyState, _) = self else { return nil }
        return emptyState
    }

    var retry: BlixButtonConfigurator? {
        guard case .failed(_, let retry) = self else { return nil }
        return retry
    }
}
