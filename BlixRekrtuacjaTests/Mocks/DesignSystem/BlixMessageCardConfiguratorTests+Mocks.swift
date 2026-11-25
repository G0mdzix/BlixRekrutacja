@testable import BlixRekrtuacja
import SwiftUI

extension BlixMessageCardConfiguratorTests {
    struct Scenario {
        let tone: BlixMessageCardConfigurator.Tone
        let iconColor: Color
        let iconBackground: Color
    }

    static let tones: [Scenario] = [
        Scenario(tone: .error, iconColor: .textNegative, iconBackground: .errorSubtle),
        Scenario(tone: .neutral, iconColor: .textSecondary, iconBackground: .fillMuted)
    ]
}
