import SwiftUI

struct BlixEmptyState: View {
    let configurator: BlixEmptyStateConfigurator

    @ScaledMetric(relativeTo: .title) private var iconSize = Size.emptyStateIcon
    @ScaledMetric(relativeTo: .title) private var badgeSize = Size.emptyStateBadge

    var body: some View {
        VStack(spacing: Spacing.medium) {
            icon
            BlixLabel(configurator: configurator.titleLabel)
            BlixLabel(configurator: configurator.messageLabel)
        }
        .padding(Spacing.extraLarge)
        .frame(maxWidth: .infinity)
    }

    private var icon: some View {
        configurator.icon.image
            .typography(.title)
            .foregroundStyle(.textPositive)
            .circled(diameter: iconSize, fill: .backgroundPrimary, border: .hairline)
            .overlay(alignment: .bottomTrailing) {
                if let badge = configurator.badge { badgeMark(badge) }
            }
    }

    private func badgeMark(_ symbol: SFSymbol) -> some View {
        symbol.image
            .typography(.footnote)
            .fontWeight(.bold)
            .foregroundStyle(.backgroundPrimary)
            .circled(diameter: badgeSize, fill: .textNegative)
    }
}

#Preview {
    VStack(spacing: Spacing.large) {
        BlixEmptyState(
            configurator: .init(
                icon: .chartUptrend,
                title: .verbatim("Choose a currency"),
                message: .verbatim("Tap a rate.")
            )
        )
        BlixEmptyState(
            configurator: .init(
                icon: .key,
                badge: .xmark,
                title: .verbatim("Invalid API key"),
                message: .verbatim("Check it.")
            )
        )
    }
    .background(.backgroundSecondary)
}
