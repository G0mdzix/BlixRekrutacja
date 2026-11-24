import SwiftUI

// MARK: - Typography
extension View {
    func typography(_ style: Typography) -> some View {
        font(style.font)
    }
}
