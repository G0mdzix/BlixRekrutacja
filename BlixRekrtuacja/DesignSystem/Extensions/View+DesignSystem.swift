import SwiftUI

// MARK: - Typography
extension View {
    func typography(_ style: Typography, monospacedDigits: Bool = false) -> some View {
        font(monospacedDigits ? style.font.monospacedDigit() : style.font)
    }
}
