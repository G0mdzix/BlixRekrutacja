extension RateSelection {
    @MainActor
    func rowConfigurator(navigator: (any MainNavigating)?) -> BlixRateRowConfigurator {
        BlixRateRowConfigurator(code: code, name: name, value: value, change: change) { [weak navigator] in
            navigator?.showRate(self)
        }
    }
}
