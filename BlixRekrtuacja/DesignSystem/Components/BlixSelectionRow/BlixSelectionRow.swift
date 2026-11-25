import SwiftUI

/// Extracted into the component library for demonstration purposes (recruitment task):
/// shows how views are built from configurable components in a larger app.
/// Used only by Settings — in production code it would stay a private view in `SettingsView`.
struct BlixSelectionRow: View {
    let configurator: BlixSelectionRowConfigurator

    var body: some View {
        Button { configurator.action() } label: {
            HStack {
                BlixLabel(configurator: configurator.label)
                Spacer()
                if configurator.isSelected {
                    SFSymbol.checkmark.image.foregroundStyle(.textPositive)
                }
            }
            .frame(minHeight: Size.minTapTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: Spacing.small) {
        BlixSelectionRow(configurator: .init(title: .verbatim("Selected"), isSelected: true) {})
        BlixSelectionRow(configurator: .init(title: .verbatim("Unselected")) {})
        BlixSelectionRow(configurator: .init(title: .verbatim("With icon"), icon: .moon) {})
    }
    .padding(Spacing.large)
}
