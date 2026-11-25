@testable import BlixRekrtuacja
import SwiftUI

extension BlixButtonConfiguratorTests {
    struct LoadingScenario {
        let isLoading: Bool
        let isEnabled: Bool
        let icon: SFSymbol?
    }

    struct StyleScenario {
        let style: BlixButtonConfigurator.Style
        let textStyle: BlixLabelConfigurator.Style
        let background: Color
        let border: Color?
    }

    static let loadingStates: [LoadingScenario] = [
        LoadingScenario(isLoading: false, isEnabled: true, icon: .copy),
        LoadingScenario(isLoading: true, isEnabled: false, icon: nil)
    ]

    static let styles: [StyleScenario] = [
        StyleScenario(style: .primary, textStyle: .onBrand, background: .brandPrimary, border: nil),
        StyleScenario(style: .secondary, textStyle: .accent, background: .backgroundPrimary, border: .hairline)
    ]
}
