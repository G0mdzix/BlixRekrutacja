import Observation

@MainActor @Observable
final class MainCoordinator: Coordinator, MainNavigating {
    var path: [MainRoute] = []
    @ObservationIgnored private(set) lazy var root = RatesViewModel(
        repository: repository,
        preferences: preferences,
        dates: dates,
        navigator: self
    )

    private let repository: any RatesRepository
    private let preferences: UserPreferences
    private let dates: DateProvider
    private let clipboard: any Clipboard

    init(
        repository: any RatesRepository,
        preferences: UserPreferences,
        dates: DateProvider,
        clipboard: any Clipboard
    ) {
        self.repository = repository
        self.preferences = preferences
        self.dates = dates
        self.clipboard = clipboard
    }

    func showRate(_ rate: RateSelection) {
        push(.rate(RateDetailViewModel(rate: rate, clipboard: clipboard)))
    }

    func showDay(_ day: DaySelection) {
        push(.day(DayRatesViewModel(selection: day, navigator: self)))
    }

    func showSettings() {
        push(.settings(SettingsViewModel(preferences: preferences)))
    }
}
