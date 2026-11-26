import Foundation
import Observation

@MainActor @Observable
final class RatesViewModel {
    enum Content {
        case loading
        case failed(BlixEmptyStateConfigurator, retry: BlixButtonConfigurator?)
        case list(baseInfo: BlixLabelConfigurator)
    }

    enum Footer: Equatable {
        case loading
        case failed(AppError)
        case loadOlderButton
    }

    private(set) var error: AppError?
    private var isLoading = false

    private let history: RatesHistory
    private let preferences: UserPreferences
    private let dates: DateProvider
    @ObservationIgnored private weak var navigator: (any MainNavigating)?

    init(
        repository: any RatesRepository,
        preferences: UserPreferences,
        dates: DateProvider,
        navigator: any MainNavigating
    ) {
        history = RatesHistory(repository: repository)
        self.preferences = preferences
        self.dates = dates
        self.navigator = navigator
    }

    var days: [DailyRates] { history.days }

    var nextDay: Date? { history.nextDay }

    var content: Content {
        if let first = days.first {
            .list(baseInfo: baseInfoConfigurator(first.base))
        } else if let error {
            .failed(error.ratesEmptyState, retry: retryButtonConfigurator(for: error))
        } else {
            .loading
        }
    }

    var footer: Footer? {
        if days.isEmpty {
            nil
        } else if let error {
            .failed(error)
        } else {
            days.count < Paging.autoLoadedDays ? .loading : .loadOlderButton
        }
    }

    func start() async {
        guard days.isEmpty, error == nil else { return }
        await loadNextDay()
        if error == nil { await loadNextDay() }
    }

    func footerAppeared() async {
        guard error == nil, days.count < Paging.autoLoadedDays else { return }
        await loadNextDay()
    }

    func loadNextDay() async {
        guard !isLoading, error?.stopsLoading != true else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            // Not the caller's task: a footer rebuilt mid-load (rotation) cancels its `.task`, the request goes on.
            try await Task { [history] in try await history.loadNext() }.value
            error = nil
        } catch {
            self.error = AppError(error)
        }
    }

    func openSettings() {
        navigator?.showSettings()
    }
}

// MARK: - UI configurators

extension RatesViewModel {
    var splashConfigurator: BlixSplashConfigurator {
        BlixSplashConfigurator(
            brand: .localized(.ratesSplashBrand),
            product: .localized(.ratesSplashProduct),
            caption: .localized(.ratesLoading)
        )
    }

    var progressConfigurator: BlixProgressRowConfigurator {
        BlixProgressRowConfigurator(text: .localized(.ratesLoadingNextDay))
    }

    var loadOlderButtonConfigurator: BlixButtonConfigurator {
        loadButton(title: .ratesLoadOlder, style: .secondary, isLoading: isLoading)
    }

    func messageCardConfigurator(_ error: AppError) -> BlixMessageCardConfigurator {
        error.ratesMessageCard(retry: retryButtonConfigurator(for: error))
    }

    func headerConfigurator(_ rates: DailyRates) -> BlixSectionHeaderConfigurator {
        let isToday = rates.day == BusinessDays.day(containing: dates.now())
        return BlixSectionHeaderConfigurator(
            title: .date(rates.day, RateDateFormat.day),
            badge: isToday ? .localized(.ratesToday) : nil,
            caption: .localized(isToday ? .ratesUpdatedAt(updateTime(rates.updatedAt)) : .ratesClosingRate)
        )
    }

    func rowConfigurators(_ rates: DailyRates) -> [BlixRateRowConfigurator] {
        selections(rates, codes: PopularCurrency.codes).map { $0.rowConfigurator(navigator: navigator) }
    }

    func showAllButtonConfigurator(_ rates: DailyRates) -> BlixButtonConfigurator? {
        guard rates.rates.count > PopularCurrency.codes.count else { return nil }
        let title = BlixLabelConfigurator.Content.localized(.ratesShowAll(rates.rates.count))
        return BlixButtonConfigurator(title: title, style: .secondary) { [weak self] in
            guard let self else { return }
            navigator?.showDay(DaySelection(day: rates.day, rates: selections(rates)))
        }
    }

    private func baseInfoConfigurator(_ base: String) -> BlixLabelConfigurator {
        BlixLabelConfigurator(text: .localized(.ratesBaseInfo(base)), style: .secondary, typography: .subheadline)
    }

    private func selections(_ rates: DailyRates, codes: [String]? = nil) -> [RateSelection] {
        rates.selections(
            comparedWith: history.day(before: rates),
            loadedDays: days,
            locale: preferences.language.locale,
            codes: codes
        )
    }

    private func retryButtonConfigurator(for error: AppError) -> BlixButtonConfigurator? {
        error.stopsLoading ? nil : loadButton(title: .commonRetry, isLoading: isLoading)
    }

    private func loadButton(
        title: LocalizedStringResource,
        style: BlixButtonConfigurator.Style = .primary,
        isLoading: Bool = false
    ) -> BlixButtonConfigurator {
        BlixButtonConfigurator(title: .localized(title), style: style, isLoading: isLoading) { [weak self] in
            guard let self else { return }
            Task { await self.loadNextDay() }
        }
    }

    private func updateTime(_ date: Date) -> String {
        let style = Date.FormatStyle(date: .omitted, time: .shortened, timeZone: dates.timeZone)
        return date.formatted(style.locale(preferences.language.locale))
    }
}

// MARK: - Constants

extension RatesViewModel {
    enum Paging {
        static let autoLoadedDays = 5
    }
}

private extension RatesViewModel {
    enum PopularCurrency {
        static let codes = ["USD", "GBP", "CHF", "PLN", "JPY"]
    }
}
