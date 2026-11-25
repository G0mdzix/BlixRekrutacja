import Foundation
import Observation

@MainActor @Observable
final class RateDetailViewModel {
    enum History {
        case hidden
        case loaded(
            header: BlixSectionHeaderConfigurator,
            chart: BlixLineChartConfigurator,
            rows: [BlixValueRowConfigurator]
        )
    }

    let rate: RateSelection
    private(set) var isCopied = false

    private let clipboard: any Clipboard

    init(rate: RateSelection, clipboard: any Clipboard) {
        self.rate = rate
        self.clipboard = clipboard
    }

    /// Copies the exact rate with a dot, not the screen's localized text, so it pastes as a number anywhere.
    func copyRate() {
        clipboard.copy(rate.value.description)
        isCopied = true
    }
}

// MARK: - UI configurators

extension RateDetailViewModel {
    var headerConfigurator: BlixSectionHeaderConfigurator {
        BlixSectionHeaderConfigurator(title: .verbatim(rate.code), caption: rate.name.map { .verbatim($0) })
    }

    var valueRowConfigurators: [BlixValueRowConfigurator] {
        let rows = [
            BlixValueRowConfigurator(title: .localized(.ratesDate), value: .date(rate.day, RateDateFormat.dayWithYear)),
            BlixValueRowConfigurator(
                title: .localized(.ratesRate(rate.base)),
                value: .number(rate.value, fractionLength: Precision.exact)
            ),
            rate.change.map {
                BlixValueRowConfigurator(
                    title: .localized(.ratesChange),
                    value: .percent($0, fractionLength: Precision.change)
                )
            },
            BlixValueRowConfigurator(
                title: .localized(.ratesInverseRate),
                value: .number(1 / rate.value, fractionLength: Precision.exact)
            )
        ]
        return rows.compactMap(\.self)
    }

    var history: History {
        guard rate.history.count >= Chart.minimumDays else { return .hidden }
        return .loaded(
            header: BlixSectionHeaderConfigurator(title: .localized(.ratesLoadedDays)),
            chart: BlixLineChartConfigurator(
                points: rate.history.reversed().map {
                    BlixLineChartConfigurator.Point(date: $0.day, value: $0.value)
                },
                dateFormat: RateDateFormat.shortDay
            ),
            rows: rate.history.map {
                BlixValueRowConfigurator(
                    title: .date($0.day, RateDateFormat.day),
                    value: .number($0.value, fractionLength: Precision.exact)
                )
            }
        )
    }

    var copyButtonConfigurator: BlixButtonConfigurator {
        BlixButtonConfigurator(
            title: .localized(isCopied ? .ratesCopied : .ratesCopyRate),
            icon: isCopied ? .checkmark : .copy
        ) { [weak self] in
            guard let self else { return }
            copyRate()
        }
    }
}

// MARK: - Constants

private extension RateDetailViewModel {
    enum Precision {
        static let exact = 6
        static let change = 2
    }

    enum Chart {
        static let minimumDays = 3
    }
}
