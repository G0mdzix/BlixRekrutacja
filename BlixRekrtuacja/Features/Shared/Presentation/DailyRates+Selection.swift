import Foundation

extension DailyRates {
    func selections(comparedWith previous: DailyRates?, locale: Locale) -> [RateSelection] {
        let previousValues = Dictionary(uniqueKeysWithValues: previous?.rates.map { ($0.code, $0.value) } ?? [])
        return rates.map { rate in
            RateSelection(
                code: rate.code,
                name: locale.localizedString(forCurrencyCode: rate.code),
                value: rate.value,
                base: base,
                day: day,
                change: previousValues[rate.code].map { (rate.value - $0) / $0 }
            )
        }
    }
}
