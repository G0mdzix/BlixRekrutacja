@testable import BlixRekrtuacja
import SwiftUI

extension AppearanceTests {
    struct Scenario {
        let appearance: Appearance
        let expectedColorScheme: ColorScheme?
    }

    static let colorSchemes: [Scenario] = [
        Scenario(appearance: .system, expectedColorScheme: nil),
        Scenario(appearance: .light, expectedColorScheme: .light),
        Scenario(appearance: .dark, expectedColorScheme: .dark)
    ]
}
