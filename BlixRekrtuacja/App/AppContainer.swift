import Foundation
import UIKit

/// The composition root: the only place that creates concrete types. Built once per launch.
@MainActor
final class AppContainer {
    let preferences: UserPreferences
    let coordinator: MainCoordinator

    init() {
        preferences = UserPreferences(store: UserDefaultsStore(defaults: .standard))
        coordinator = MainCoordinator(
            repository: Self.makeRatesRepository(bundle: .main),
            preferences: preferences
        ) { UIPasteboard.general.string = $0 }
    }

    /// Fixer through an ephemeral session (the key travels in the URL, so nothing may be cached on disk),
    /// behind the on-device cache.
    private static func makeRatesRepository(bundle: Bundle) -> any RatesRepository {
        let client = URLSessionHTTPClient(baseURL: bundle.fixerBaseURL, session: URLSession(configuration: .ephemeral))
        return CachedRatesRepository(
            remote: RemoteRatesRepository(client: client, apiKey: bundle.fixerAPIKey),
            cache: SwiftDataRatesCache.onDiskOrInMemory()
        )
    }
}
