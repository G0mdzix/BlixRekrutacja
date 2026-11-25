import SwiftUI

/// Title on its own line, so a long date never squeezes the badge and the caption.
struct BlixSectionHeader: View {
    let configurator: BlixSectionHeaderConfigurator

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            BlixLabel(configurator: configurator.titleLabel)
            if configurator.hasDetails {
                HStack(spacing: Spacing.small) {
                    if let badge = configurator.badgeLabel {
                        BlixLabel(configurator: badge)
                            .padding(.horizontal, Spacing.small)
                            .background(.brandPrimary, in: .capsule)
                    }
                    if let caption = configurator.captionLabel {
                        BlixLabel(configurator: caption)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: Spacing.extraLarge) {
        BlixSectionHeader(
            configurator: .init(
                title: .verbatim("Wednesday, 25 November"),
                badge: .verbatim("Today"),
                caption: .verbatim("Updated 10:00")
            )
        )
        BlixSectionHeader(
            configurator: .init(title: .verbatim("Tuesday, 24 November"), caption: .verbatim("Closing rate"))
        )
        BlixSectionHeader(configurator: .init(title: .verbatim("Monday, 23 November")))
    }
    .padding(Spacing.large)
}
