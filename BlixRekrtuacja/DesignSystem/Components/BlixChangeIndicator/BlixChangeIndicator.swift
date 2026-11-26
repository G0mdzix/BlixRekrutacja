import SwiftUI

struct BlixChangeIndicator: View {
    let configurator: BlixChangeIndicatorConfigurator

    var body: some View {
        BlixLabel(configurator: configurator.label)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.small) {
        BlixChangeIndicator(configurator: .init(change: 0.0028))
        BlixChangeIndicator(configurator: .init(change: -0.0115))
        BlixChangeIndicator(configurator: .init(change: 0))
    }
    .padding(Spacing.large)
}
