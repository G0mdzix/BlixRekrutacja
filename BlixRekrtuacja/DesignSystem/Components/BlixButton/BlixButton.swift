import SwiftUI

struct BlixButton: View {
    let configurator: BlixButtonConfigurator

    var body: some View {
        Button { configurator.action() } label: {
            HStack(spacing: Spacing.small) {
                if configurator.isLoading { ProgressView() }
                BlixLabel(configurator: configurator.label)
            }
        }
        .buttonStyle(BlixButtonStyle(style: configurator.style))
        .disabled(!configurator.isEnabled)
    }
}

#Preview {
    VStack(spacing: Spacing.medium) {
        BlixButton(configurator: .init(title: .verbatim("Copy rate"), icon: .copy) {})
        BlixButton(configurator: .init(title: .verbatim("Load older days"), style: .secondary) {})
        BlixButton(configurator: .init(title: .verbatim("Try again"), style: .secondary, isLoading: true) {})
    }
    .padding(Spacing.large)
}
