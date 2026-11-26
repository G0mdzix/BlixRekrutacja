import Foundation

extension DailyRates {
    func selections(
        comparedWith previous: DailyRates?,
        loadedDays: [DailyRates],
        locale: Locale,
        codes: [String]? = nil
    ) -> [RateSelection] {
        let previousValues = Dictionary(uniqueKeysWithValues: previous?.rates.map { ($0.code, $0.value) } ?? [])
        return rates.filter { codes?.contains($0.code) ?? true }.map { rate in
            RateSelection(
                code: rate.code,
                name: locale.localizedString(forCurrencyCode: rate.code),
                value: rate.value,
                base: base,
                day: day,
                change: previousValues[rate.code].map { (rate.value - $0) / $0 },
                history: loadedDays.compactMap { loaded in
                    loaded.rates.first { $0.code == rate.code }
                        .map { RateSelection.Point(day: loaded.day, value: $0.value) }
                }
            )
        }
    }
}
