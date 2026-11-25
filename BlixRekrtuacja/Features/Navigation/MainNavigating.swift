@MainActor
protocol MainNavigating: AnyObject {
    func showRate(_ rate: RateSelection)
    func showDay(_ day: DaySelection)
    func showSettings()
}
