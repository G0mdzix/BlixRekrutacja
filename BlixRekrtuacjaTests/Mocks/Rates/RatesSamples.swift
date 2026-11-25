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

    // MARK: - Screens

    static let tuesday = Date(iso: "2026-11-24T00:00:00Z")
    static let wednesdayUpdate = Date(iso: "2026-11-25T11:00:00Z")

    /// A day of the market as Fixer sends it: twelve currencies against EUR. Wednesday is today, older days are
    /// closed; Monday's rates stand for every day before it.
    static func market(on day: Date) -> DailyRates {
        let values = switch day {
        case wednesday: marketWednesday
        case tuesday: marketTuesday
        default: marketMonday
        }
        return DailyRates(
            day: day,
            base: "EUR",
            updatedAt: day == wednesday ? wednesdayUpdate : day,
            rates: values.map { CurrencyRate(code: $0.key, value: Decimal(exact: $0.value)) }.sorted()
        )
    }

    /// Only two currencies, so a whole day and the footer below it fit on one screen.
    static func shortMarket(on day: Date) -> DailyRates {
        let rates = market(on: day)
        return DailyRates(
            day: rates.day,
            base: rates.base,
            updatedAt: rates.updatedAt,
            rates: rates.rates.filter { ["PLN", "USD"].contains($0.code) }
        )
    }

    /// Wednesday's market as the screens show it: Polish names and the change since Tuesday.
    static let wednesdaySelections = [
        selection("AUD", "dolar australijski", "1.681204", change: "0.0013"),
        selection("CAD", "dolar kanadyjski", "1.524417", change: "0.0016"),
        selection("CHF", "frank szwajcarski", "0.922196", change: "0"),
        selection("CZK", "korona czeska", "24.312050", change: "-0.0018"),
        selection("DKK", "korona duńska", "7.461208", change: "0.0001"),
        selection("GBP", "funt szterling", "0.838894", change: "-0.0016"),
        selection("HUF", "forint węgierski", "391.420310", change: "-0.0035"),
        selection("JPY", "jen japoński", "173.978128", change: "0.0062"),
        selection("NOK", "korona norweska", "11.732118", change: "-0.0024"),
        selection("PLN", "złoty polski", "4.259811", change: "0.0020"),
        selection("SEK", "korona szwedzka", "11.204377", change: "0.0016"),
        selection("USD", "dolar amerykański", "1.097273", change: "0.0020")
    ]

    /// A short day for search and navigation: two names share "dolar", one has a diacritic.
    static let threeCurrencyDay = DaySelection(day: wednesday, rates: [
        selection("AUD", "dolar australijski", "1.5", change: nil),
        selection("PLN", "złoty polski", "4.459811", change: nil),
        selection("USD", "dolar amerykański", "1.5", change: nil)
    ])

    static func selection(_ code: String, _ name: String, _ value: String, change: String?) -> RateSelection {
        RateSelection(
            code: code,
            name: name,
            value: Decimal(exact: value),
            base: "EUR",
            day: wednesday,
            change: change.map { Decimal(exact: $0) }
        )
    }

    private static let marketWednesday = [
        "AUD": "1.681204", "CAD": "1.524417", "CHF": "0.922196", "CZK": "24.312050",
        "DKK": "7.461208", "GBP": "0.838894", "HUF": "391.420310", "JPY": "173.978128",
        "NOK": "11.732118", "PLN": "4.259811", "SEK": "11.204377", "USD": "1.097273"
    ]

    private static let marketMonday = [
        "AUD": "1.683560", "CAD": "1.519874", "CHF": "0.924310", "CZK": "24.341877",
        "DKK": "7.460519", "GBP": "0.838102", "HUF": "393.115904", "JPY": "172.551260",
        "NOK": "11.741095", "PLN": "4.262013", "SEK": "11.201448", "USD": "1.092877"
    ]

    private static let marketTuesday = [
        "AUD": "1.679015", "CAD": "1.521930", "CHF": "0.922196", "CZK": "24.355102",
        "DKK": "7.460811", "GBP": "0.840215", "HUF": "392.801447", "JPY": "172.904115",
        "NOK": "11.760034", "PLN": "4.251240", "SEK": "11.187006", "USD": "1.095108"
    ]

    static func fixerResponse(_ body: String = fixerSaturdayBody) throws -> FixerRatesResponse {
        try JSONDecoder().decode(FixerRatesResponse.self, from: Data(body.utf8))
    }
}
