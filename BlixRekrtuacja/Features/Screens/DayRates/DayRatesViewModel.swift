import Foundation
import Observation

@MainActor @Observable
final class DayRatesViewModel {
    enum Results {
        case rows([BlixRateRowConfigurator])
        case noResults(BlixEmptyStateConfigurator)
    }

    var query = ""

    private let selection: DaySelection
    private let searchKeys: [String]
    @ObservationIgnored private weak var navigator: (any MainNavigating)?

    init(selection: DaySelection, navigator: any MainNavigating) {
        self.selection = selection
        self.navigator = navigator
        searchKeys = selection.rates.map { Self.searchKey("\($0.code) \($0.name ?? "")") }
    }

    private var matchingRates: [RateSelection] {
        let query = Self.searchKey(query.trimmingCharacters(in: .whitespaces))
        guard !query.isEmpty else { return selection.rates }
        return zip(selection.rates, searchKeys).filter { $0.1.contains(query) }.map(\.0)
    }

    private static func searchKey(_ text: String) -> String {
        text.applyingTransform(Search.foldingTransform, reverse: false) ?? text.lowercased()
    }
}

// MARK: - UI configurators

extension DayRatesViewModel {
    var headerConfigurator: BlixSectionHeaderConfigurator {
        BlixSectionHeaderConfigurator(
            title: .date(selection.day, RateDateFormat.day),
            caption: .localized(.ratesAllCurrencies(selection.rates.count))
        )
    }

    var results: Results {
        let rates = matchingRates
        guard rates.isEmpty else { return .rows(rates.map { $0.rowConfigurator(navigator: navigator) }) }
        return .noResults(BlixEmptyStateConfigurator(
            icon: .search,
            title: .localized(.ratesNoResultsTitle),
            message: .localized(.ratesNoResultsMessage(query))
        ))
    }
}

// MARK: - Constants

private extension DayRatesViewModel {
    enum Search {
        static let foldingTransform = StringTransform("Latin-ASCII; Lower")
    }
}
