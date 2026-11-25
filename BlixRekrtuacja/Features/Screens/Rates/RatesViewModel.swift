import Foundation
import Observation

@MainActor @Observable
final class RatesViewModel {
    enum Content {
        case loading
        case failed(BlixEmptyStateConfigurator, retry: BlixButtonConfigurator?)
        case list
    }

    enum Footer: Equatable {
        case loading
        case failed(AppError)
        case quotaReached
        case loadOlderButton
    }

    private(set) var days: [DailyRates] = []
    private(set) var error: AppError?
    /// Counts retries that failed again, so the view can shake the error in place.
    private(set) var failedRetries = 0

    private let repository: any RatesRepository
    private let preferences: UserPreferences
    private let now: () -> Date
    private let timeZone: TimeZone
    private let onSelectRate: @MainActor (RateSelection) -> Void
    private let onShowDay: @MainActor (DaySelection) -> Void
    private let onOpenSettings: @MainActor () -> Void
    private var isLoading = false
    /// The next older working day. It moves after every load, even one that returned a day already shown,
    /// so the footer's auto-load keys on it and never stalls.
    private(set) var nextDay: Date?

    init(
        repository: any RatesRepository,
        preferences: UserPreferences,
        now: @escaping () -> Date = { Date() },
        timeZone: TimeZone = .autoupdatingCurrent,
        onSelectRate: @escaping @MainActor (RateSelection) -> Void,
        onShowDay: @escaping @MainActor (DaySelection) -> Void,
        onOpenSettings: @escaping @MainActor () -> Void
    ) {
        self.repository = repository
        self.preferences = preferences
        self.now = now
        self.timeZone = timeZone
        self.onSelectRate = onSelectRate
        self.onShowDay = onShowDay
        self.onOpenSettings = onOpenSettings
    }

    var content: Content {
        if let emptyState = emptyStateConfigurator { return .failed(emptyState, retry: emptyStateButtonConfigurator) }
        return days.isEmpty ? .loading : .list
    }

    var footer: Footer? {
        guard !days.isEmpty else { return nil }
        if let error { return error == .quotaExceeded ? .quotaReached : .failed(error) }
        return days.count < Paging.autoLoadedDays ? .loading : .loadOlderButton
    }

    /// Runs on every appearance: it loads only a screen that is still empty; an error waits for the user's retry.
    func start() async {
        guard days.isEmpty, error == nil else { return }
        await loadNextDay()
        if error == nil { await loadNextDay() }
    }

    func footerAppeared() async {
        guard error == nil, days.count < Paging.autoLoadedDays else { return }
        await loadNextDay()
    }

    /// A retry keeps the error on screen until it succeeds, so the failure never jumps to a spinner and back.
    func loadNextDay() async {
        guard !isLoading, !Self.stopsLoading(error) else { return }
        let isRetry = error != nil
        isLoading = true
        defer { isLoading = false }
        do {
            let requested = nextDay
            let rates = try await fetchNextDay()
            nextDay = BusinessDays.previous(before: min(rates.day, requested ?? rates.day))
            if !days.contains(where: { $0.day == rates.day }) { days.append(rates) }
            error = nil
        } catch {
            self.error = AppError(error)
            if isRetry, self.error != nil { failedRetries += 1 }
        }
    }

    func openSettings() {
        onOpenSettings()
    }

    private static func stopsLoading(_ error: AppError?) -> Bool {
        error == .quotaExceeded || error == .missingAPIKey
    }

    private func fetchNextDay() async throws -> DailyRates {
        guard let nextDay else { return try await repository.latest() }
        return try await repository.rates(on: nextDay)
    }
}

// MARK: - UI configurators

extension RatesViewModel {
    var baseInfoConfigurator: BlixLabelConfigurator? {
        days.first.map {
            BlixLabelConfigurator(
                text: .localized(.ratesBaseInfo($0.base)),
                style: .secondary,
                typography: .subheadline
            )
        }
    }

    var progressConfigurator: BlixProgressRowConfigurator {
        BlixProgressRowConfigurator(text: .localized(days.isEmpty ? .ratesLoading : .ratesLoadingNextDay))
    }

    var emptyStateConfigurator: BlixEmptyStateConfigurator? {
        guard days.isEmpty, let error else { return nil }
        return switch error {
        case .missingAPIKey:
            BlixEmptyStateConfigurator(
                icon: .key,
                title: .localized(.ratesMissingKeyTitle),
                message: .localized(error.message)
            )
        case .invalidAPIKey:
            BlixEmptyStateConfigurator(
                icon: .key,
                badge: .xmark,
                title: .localized(.ratesInvalidKeyTitle),
                message: .localized(error.message)
            )
        default:
            BlixEmptyStateConfigurator(
                icon: .wifiSlash,
                title: .localized(.ratesFirstLoadFailedTitle),
                message: .localized(error.message)
            )
        }
    }

    /// No retry for a missing key: it is built into the app, so only a rebuild helps.
    var emptyStateButtonConfigurator: BlixButtonConfigurator? {
        Self.stopsLoading(error) ? nil : retryButtonConfigurator
    }

    private var retryButtonConfigurator: BlixButtonConfigurator {
        BlixButtonConfigurator(title: .localized(.commonRetry), isLoading: isLoading) { [weak self] in
            guard let self else { return }
            Task { await self.loadNextDay() }
        }
    }

    var loadOlderButtonConfigurator: BlixButtonConfigurator {
        BlixButtonConfigurator(title: .localized(.ratesLoadOlder), style: .secondary) { [weak self] in
            guard let self else { return }
            Task { await self.loadNextDay() }
        }
    }

    var quotaCardConfigurator: BlixMessageCardConfigurator {
        BlixMessageCardConfigurator(
            icon: .hourglass,
            tone: .neutral,
            title: .localized(.ratesQuotaTitle),
            message: .localized(.ratesQuotaMessage)
        )
    }

    func failedCardConfigurator(_ error: AppError) -> BlixMessageCardConfigurator {
        BlixMessageCardConfigurator(
            icon: .wifiSlash,
            title: .localized(.ratesLoadFailedTitle),
            message: .localized(error.message),
            button: Self.stopsLoading(error) ? nil : retryButtonConfigurator
        )
    }

    func headerConfigurator(_ rates: DailyRates) -> BlixSectionHeaderConfigurator {
        let isToday = rates.day == BusinessDays.day(containing: now())
        return BlixSectionHeaderConfigurator(
            title: .date(rates.day, RateDateFormat.day),
            badge: isToday ? .localized(.ratesToday) : nil,
            caption: .localized(isToday ? .ratesUpdatedAt(updateTime(rates.updatedAt)) : .ratesClosingRate)
        )
    }

    func rowConfigurators(_ rates: DailyRates) -> [BlixRateRowConfigurator] {
        selections(rates) { PopularCurrency.codes.contains($0.code) }
            .map { selection in
                selection.rowConfigurator { [weak self] in
                    guard let self else { return }
                    onSelectRate(selection)
                }
            }
    }

    func showAllButtonConfigurator(_ rates: DailyRates) -> BlixButtonConfigurator? {
        guard rates.rates.count > PopularCurrency.codes.count else { return nil }
        let title = BlixLabelConfigurator.Content.localized(.ratesShowAll(rates.rates.count))
        return BlixButtonConfigurator(title: title, style: .secondary) { [weak self] in
            guard let self else { return }
            onShowDay(DaySelection(day: rates.day, rates: selections(rates)))
        }
    }

    private func selections(
        _ rates: DailyRates,
        including isIncluded: (CurrencyRate) -> Bool = { _ in true }
    ) -> [RateSelection] {
        let previous = previousValues(before: rates.day)
        return rates.rates.filter(isIncluded).map { rate in
            RateSelection(
                code: rate.code,
                name: preferences.language.locale.localizedString(forCurrencyCode: rate.code),
                value: rate.value,
                base: rates.base,
                day: rates.day,
                change: previous[rate.code].map { (rate.value - $0) / $0 }
            )
        }
    }

    private func previousValues(before day: Date) -> [String: Decimal] {
        guard let index = days.firstIndex(where: { $0.day == day }), days.indices.contains(index + 1) else {
            return [:]
        }
        return Dictionary(uniqueKeysWithValues: days[index + 1].rates.map { ($0.code, $0.value) })
    }

    private func updateTime(_ date: Date) -> String {
        let style = Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)
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
