@testable import BlixRekrtuacja
import Foundation

enum RatesSamples {
    static let friday = Date(iso: "2026-11-20T00:00:00Z")
    static let fridayNoon = Date(iso: "2026-11-20T12:00:00Z")
    static let saturday = Date(iso: "2026-11-21T00:00:00Z")
    static let saturdayNoon = Date(iso: "2026-11-21T12:00:00Z")
    static let wednesday = Date(iso: "2026-11-25T00:00:00Z")
    static let wednesdayNoon = Date(iso: "2026-11-25T12:00:00Z")

    static func rates(on day: Date, pln: String = "4.459811") -> DailyRates {
        DailyRates(
            day: day,
            base: "EUR",
            updatedAt: day,
            rates: [
                CurrencyRate(code: "PLN", value: Decimal(exact: pln)),
                CurrencyRate(code: "USD", value: Decimal(exact: "1.097273"))
            ]
        )
    }

    /// A real Fixer answer for Saturday, 21 November 2026.
    static let fixerSaturdayBody = """
        {"success":true,"timestamp":1795305599,"historical":true,"base":"EUR","date":"2026-11-21",\
        "rates":{"USD":1.097273,"GBP":0.838894,"CHF":0.922196,"PLN":4.459811,"JPY":173.978128}}
        """

    static let fixerSaturday = DailyRates(
        day: saturday,
        base: "EUR",
        updatedAt: Date(timeIntervalSince1970: 1_795_305_599),
        rates: [
            CurrencyRate(code: "CHF", value: Decimal(exact: "0.922196")),
            CurrencyRate(code: "GBP", value: Decimal(exact: "0.838894")),
            CurrencyRate(code: "JPY", value: Decimal(exact: "173.978128")),
            CurrencyRate(code: "PLN", value: Decimal(exact: "4.459811")),
            CurrencyRate(code: "USD", value: Decimal(exact: "1.097273"))
        ]
    )

    static func fixerResponse(_ body: String = fixerSaturdayBody) throws -> FixerRatesResponse {
        try JSONDecoder().decode(FixerRatesResponse.self, from: Data(body.utf8))
    }
}
