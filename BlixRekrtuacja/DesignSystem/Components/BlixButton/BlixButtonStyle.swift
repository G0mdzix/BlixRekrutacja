import SwiftUI

/// Pressed and disabled states dim the content only; the fill stays solid.
struct BlixButtonStyle: ButtonStyle {
    let style: BlixButtonConfigurator.Style

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(contentOpacity(isPressed: configuration.isPressed))
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.small)
            .frame(maxWidth: .infinity, minHeight: Size.minTapTarget)
            .modifier(BlixSurface(fill: style.background, border: style.border, shape: Self.shape))
    }

    private static let shape = RoundedRectangle(cornerRadius: Radius.medium)

    private func contentOpacity(isPressed: Bool) -> Double {
        guard isEnabled else { return Opacity.disabled }
        return isPressed ? Opacity.pressed : Opacity.opaque
    }
}
