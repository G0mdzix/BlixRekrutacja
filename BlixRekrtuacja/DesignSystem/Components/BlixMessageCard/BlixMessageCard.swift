import SwiftUI

/// An inline message where the missing content would be, e.g. a day that failed to load.
struct BlixMessageCard: View {
    let configurator: BlixMessageCardConfigurator

    @ScaledMetric(relativeTo: .headline) private var iconSize = Size.messageIcon

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            BlixAdaptiveRow(
                alignment: .top,
                spacing: Spacing.medium,
                stackedSpacing: Spacing.medium,
                spreadsApart: false
            ) {
                configurator.icon.image
                    .foregroundStyle(configurator.tone.iconColor)
                    .circled(diameter: iconSize, fill: configurator.tone.iconBackground)
            } trailing: {
                VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                    BlixLabel(configurator: configurator.titleLabel)
                    BlixLabel(configurator: configurator.messageLabel)
                }
            }
            if let button = configurator.button { BlixButton(configurator: button) }
        }
        .padding(Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(.primary)
    }
}

#Preview {
    VStack(spacing: Spacing.medium) {
        BlixMessageCard(
            configurator: .init(
                icon: .wifiSlash,
                title: .verbatim("Couldn't load the next day"),
                message: .verbatim("No internet connection. Loaded days are still available."),
                button: .init(title: .verbatim("Try again"), style: .secondary) {}
            )
        )
        BlixMessageCard(
            configurator: .init(
                icon: .hourglass,
                tone: .neutral,
                title: .verbatim("Limit reached"),
                message: .verbatim("Try later.")
            )
        )
    }
    .padding(Spacing.large)
    .background(.backgroundSecondary)
}
