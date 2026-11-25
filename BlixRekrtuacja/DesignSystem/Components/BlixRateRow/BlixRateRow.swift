import SwiftUI

struct BlixRateRow: View {
    let configurator: BlixRateRowConfigurator

    var body: some View {
        if let action = configurator.action {
            Button { action() } label: { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        BlixAdaptiveRow {
            VStack(alignment: .leading, spacing: .zero) {
                BlixLabel(configurator: configurator.codeLabel)
                if let name = configurator.nameLabel { BlixLabel(configurator: name) }
            }
        } trailing: {
            BlixLabel(configurator: configurator.valueLabel)
            if let change = configurator.changeIndicator { BlixChangeIndicator(configurator: change) }
        }
        .padding(.vertical, Spacing.small)
        .padding(.horizontal, Spacing.large)
        .frame(maxWidth: .infinity, minHeight: Size.minTapTarget, alignment: .leading)
        .background(configurator.background)
        .contentShape(.rect)
    }
}

#Preview {
    VStack(spacing: .zero) {
        BlixRateRow(configurator: .init(code: "PLN", name: "Polish zloty", value: 4.459811, change: 0.0028) {})
        BlixRateRow(configurator: .init(code: "USD", name: "US dollar", value: 1.097273, change: -0.0011))
        BlixRateRow(configurator: .init(code: "GBP", name: "British pound", value: 0.838894))
        BlixRateRow(configurator: .init(code: "JPY", value: 173.978128, change: 0.0042, isSelected: true))
    }
}
