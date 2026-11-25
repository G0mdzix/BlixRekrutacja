import Observation

/// The only coordinator: creates every screen's ViewModel, wires its intents to navigation and carries it in a route.
@MainActor @Observable
final class MainCoordinator: Coordinator {
    var path: [MainRoute] = []
    /// The first screen, built once: its intents are wired to this coordinator.
    @ObservationIgnored lazy var root = makeRoot()

    private let repository: any RatesRepository
    private let preferences: UserPreferences
    private let copy: @MainActor (String) -> Void

    init(
        repository: any RatesRepository,
        preferences: UserPreferences,
        copy: @escaping @MainActor (String) -> Void
    ) {
        self.repository = repository
        self.preferences = preferences
        self.copy = copy
    }

    private func makeRoot() -> RatesViewModel {
        RatesViewModel(
            repository: repository,
            preferences: preferences,
            onSelectRate: { [weak self] rate in
                guard let self else { return }
                showRate(rate)
            },
            onShowDay: { [weak self] day in
                guard let self else { return }
                showDay(day)
            },
            onOpenSettings: { [weak self] in
                guard let self else { return }
                showSettings()
            }
        )
    }

    func showRate(_ rate: RateSelection) {
        push(.rate(RateDetailViewModel(rate: rate, copy: copy)))
    }

    func showDay(_ day: DaySelection) {
        push(.day(DayRatesViewModel(selection: day) { [weak self] rate in
            guard let self else { return }
            showRate(rate)
        }))
    }

    func showSettings() {
        push(.settings(SettingsViewModel(preferences: preferences)))
    }
}
