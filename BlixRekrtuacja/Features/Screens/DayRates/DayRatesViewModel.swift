import Foundation
import Observation

@MainActor @Observable
final class DayRatesViewModel {
    private let selection: DaySelection

    private let onSelectRate: @MainActor (RateSelection) -> Void
    private let searchKeys: [String]

    init(selection: DaySelection, onSelectRate: @escaping @MainActor (RateSelection) -> Void) {
        self.selection = selection
        self.onSelectRate = onSelectRate
        searchKeys = selection.rates.map { Self.searchKey("\($0.code) \($0.name ?? "")") }
    }

    func rates(matching query: String) -> [RateSelection] {
        let query = Self.searchKey(query.trimmingCharacters(in: .whitespaces))
        guard !query.isEmpty else { return selection.rates }
        return zip(selection.rates, searchKeys).filter { $0.1.contains(query) }.map(\.0)
    }

    private static func searchKey(_ text: String) -> String {
        text.applyingTransform(Search.foldingTransform, reverse: false) ?? text.lowercased()
    }
}

extension DayRatesViewModel: nonisolated Hashable {
    nonisolated static func == (lhs: DayRatesViewModel, rhs: DayRatesViewModel) -> Bool { lhs === rhs }

    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}

// MARK: - UI configurators

extension DayRatesViewModel {
    var headerConfigurator: BlixSectionHeaderConfigurator {
        BlixSectionHeaderConfigurator(
            title: .date(selection.day, RateDateFormat.day),
            caption: .localized(.ratesAllCurrencies(selection.rates.count))
        )
    }

    func rowConfigurators(matching query: String) -> [BlixRateRowConfigurator] {
        rates(matching: query).map { rate in
            rate.rowConfigurator { [weak self] in
                guard let self else { return }
                onSelectRate(rate)
            }
        }
    }

    func noResultsConfigurator(for query: String) -> BlixEmptyStateConfigurator {
        BlixEmptyStateConfigurator(
            icon: .search,
            title: .localized(.ratesNoResultsTitle),
            message: .localized(.ratesNoResultsMessage(query))
        )
    }
}

// MARK: - Constants

private extension DayRatesViewModel {
    enum Search {
        static let foldingTransform = StringTransform("Latin-ASCII; Lower")
    }
}
