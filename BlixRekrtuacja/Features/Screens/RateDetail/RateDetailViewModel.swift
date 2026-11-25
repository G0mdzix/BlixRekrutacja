import Foundation
import Observation

@MainActor @Observable
final class RateDetailViewModel {
    let rate: RateSelection
    private(set) var isCopied = false

    private let copy: @MainActor (String) -> Void

    init(rate: RateSelection, copy: @escaping @MainActor (String) -> Void) {
        self.rate = rate
        self.copy = copy
    }

    /// Copies the exact rate with a dot, not the screen's localized text, so it pastes as a number anywhere.
    func copyRate() {
        copy(rate.value.description)
        isCopied = true
    }
}

extension RateDetailViewModel: nonisolated Hashable {
    nonisolated static func == (lhs: RateDetailViewModel, rhs: RateDetailViewModel) -> Bool { lhs === rhs }

    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
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
}
