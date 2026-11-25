import SwiftUI

// MARK: - Card background
extension View {
    func cardBackground(_ background: CardBackground) -> some View {
        self.background(background.color, in: .rect(cornerRadius: Radius.large))
    }
}

// MARK: - Typography
extension View {
    func typography(_ style: Typography) -> some View {
        font(style.font)
    }
}
