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
        .typography(configurator.typography)
        .fontWeight(configurator.weight)
        .foregroundStyle(configurator.style.color)
    }

    private var text: some View {
        configurator.text.text.multilineTextAlignment(configurator.alignment)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.medium) {
        BlixLabel(configurator: .init(text: .verbatim("Large title"), typography: .largeTitle))
        BlixLabel(configurator: .init(text: .verbatim("Headline with icon"), typography: .headline, icon: .paintbrush))
        BlixLabel(configurator: .init(text: .verbatim("Semibold with icon"), weight: .semibold, icon: .moon))
        BlixLabel(configurator: .init(text: .verbatim("Jan Kowalski"), style: .secondary, typography: .subheadline))
        BlixLabel(
            configurator: .init(
                text: .verbatim("A long centered text that wraps onto several lines at larger text sizes."),
                alignment: .center
            )
        )
    }
    .padding(Spacing.large)
}
