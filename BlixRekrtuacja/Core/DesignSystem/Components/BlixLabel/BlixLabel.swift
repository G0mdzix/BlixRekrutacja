import SwiftUI

struct BlixLabel: View {
    let configurator: BlixLabelConfigurator

    var body: some View {
        Group {
            if let icon = configurator.icon {
                Label { text } icon: { icon.image }
            } else {
                text
            }
        }
        .font(configurator.typography.font)
        .fontWeight(configurator.weight)
        .foregroundStyle(configurator.style.color)
    }

    private var text: some View {
        configurator.text.text.multilineTextAlignment(configurator.alignment)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.medium) {
        BlixLabel(configurator: .init(text: .localized(.settingsTitle), typography: .largeTitle))
        BlixLabel(
            configurator: .init(text: .localized(.settingsAppearance), typography: .headline, icon: .paintbrush)
        )
        BlixLabel(configurator: .init(text: .localized(.appearanceDark), weight: .semibold, icon: .moon))
        BlixLabel(configurator: .init(text: .verbatim("Jan Kowalski"), style: .secondary, typography: .subheadline))
        BlixLabel(configurator: .init(text: .localized(.errorOfflineMessage), alignment: .center))
    }
    .padding(Spacing.large)
}
