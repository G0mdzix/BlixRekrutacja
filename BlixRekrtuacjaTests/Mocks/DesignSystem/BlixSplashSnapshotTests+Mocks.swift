@testable import BlixRekrtuacja
import Foundation

extension BlixSplashSnapshotTests {
    struct Scenario {
        let name: String
        let isShown: Bool
    }

    /// `launch-frame` must match the launch screen: only the centred logo.
    nonisolated static let variants: [Scenario] = [
        Scenario(name: "launch-frame", isShown: false),
        Scenario(name: "shown", isShown: true)
    ]

    static let configurator = BlixSplashConfigurator(
        brand: .localized(.ratesSplashBrand),
        product: .localized(.ratesSplashProduct),
        caption: .localized(.ratesLoading)
    )
}
