struct BlixSelectionRowConfigurator {
    let label: BlixLabelConfigurator
    var isSelected = false
    let action: @MainActor () -> Void
}
