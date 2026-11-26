import Foundation

/// The composition root: the only place that creates concrete types. Built once per launch.
@MainActor
final class AppContainer {
    let preferences: UserPreferences
    let coordinator: MainCoordinator

    init() {
        let dates = DateProvider.system
        preferences = UserPreferences(store: UserDefaultsStore(defaults: .standard))
        coordinator = MainCoordinator(
            repository: Self.makeRatesRepository(bundle: .main, dates: dates),
            preferences: preferences,
            dates: dates,
            clipboard: SystemClipboard()
        )
    }

    /// Fixer through an ephemeral session (the key travels in the URL, so nothing may be cached on disk),
    /// behind the on-device cache.
    private static func makeRatesRepository(bundle: Bundle, dates: DateProvider) -> any RatesRepository {
        let client = URLSessionHTTPClient(baseURL: bundle.fixerBaseURL, session: URLSession(configuration: .ephemeral))
        return CachedRatesRepository(
            remote: RemoteRatesRepository(client: client, apiKey: bundle.fixerAPIKey),
            cache: SwiftDataRatesCache.onDiskOrInMemory(),
            dates: dates
        )
    }
}
