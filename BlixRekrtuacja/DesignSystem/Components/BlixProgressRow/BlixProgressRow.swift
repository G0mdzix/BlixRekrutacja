import SwiftUI

struct BlixProgressRow: View {
    let configurator: BlixProgressRowConfigurator

    var body: some View {
        HStack(spacing: Spacing.small) {
            ProgressView()
            BlixLabel(configurator: configurator.label)
        }
        .frame(maxWidth: .infinity, minHeight: Size.minTapTarget)
    }
}

#Preview {
    BlixProgressRow(configurator: .init(text: .verbatim("Loading the next day…")))
        .padding(Spacing.large)
}
