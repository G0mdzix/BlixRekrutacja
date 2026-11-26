import SwiftUI

struct BlixAdaptiveRow<Leading: View, Trailing: View>: View {
    var alignment = VerticalAlignment.center
    var spacing = Spacing.small
    var stackedSpacing = Spacing.extraSmall
    var spreadsApart = true
    @ViewBuilder let leading: Leading
    @ViewBuilder let trailing: Trailing

    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        layout {
            leading
            if isSpread { Spacer(minLength: Spacing.small) }
            VStack(alignment: isSpread ? .trailing : .leading, spacing: .zero) { trailing }
        }
    }

    private var isStacked: Bool { typeSize.isAccessibilitySize }

    private var isSpread: Bool { spreadsApart && !isStacked }

    /// `AnyLayout` keeps the children's identity when the text size crosses into accessibility sizes.
    private var layout: AnyLayout {
        isStacked
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: stackedSpacing))
            : AnyLayout(HStackLayout(alignment: alignment, spacing: spacing))
    }
}

#Preview {
    VStack(spacing: Spacing.large) {
        BlixAdaptiveRow {
            BlixLabel(configurator: .init(text: .verbatim("Inverse rate"), style: .secondary))
        } trailing: {
            BlixLabel(configurator: .init(text: .verbatim("0.224225"), monospacedDigits: true))
        }
        BlixAdaptiveRow(spreadsApart: false) {
            SFSymbol.wifiSlash.image
        } trailing: {
            BlixLabel(configurator: .init(text: .verbatim("Packed: the trailing content follows the leading one.")))
        }
    }
    .padding(Spacing.large)
}
