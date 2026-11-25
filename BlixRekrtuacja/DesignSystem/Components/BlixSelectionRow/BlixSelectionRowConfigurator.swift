struct BlixSelectionRowConfigurator {
    let title: BlixLabelConfigurator.Content
    var icon: SFSymbol?
    var isSelected = false
    let action: @MainActor () -> Void

    var label: BlixLabelConfigurator {
        BlixLabelConfigurator(text: title, icon: icon)
    }
}
