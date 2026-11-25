import SwiftUI

struct BlixValueRow: View {
    let configurator: BlixValueRowConfigurator

    var body: some View {
        BlixAdaptiveRow {
            BlixLabel(configurator: configurator.titleLabel)
        } trailing: {
            BlixLabel(configurator: configurator.valueLabel)
        }
        .frame(maxWidth: .infinity, minHeight: Size.minTapTarget, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: .zero) {
        BlixValueRow(configurator: .init(title: .verbatim("Inverse rate"), value: .verbatim("1 PLN = 0.224225 EUR")))
        BlixValueRow(configurator: .init(title: .verbatim("Tue, 24 Nov"), value: .number(4.437007, fractionLength: 6)))
    }
    .padding(Spacing.large)
}
