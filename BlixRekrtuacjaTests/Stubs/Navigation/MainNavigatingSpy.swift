@testable import BlixRekrtuacja

@MainActor
final class MainNavigatingSpy: MainNavigating {
    enum Event: Equatable {
        case rate(RateSelection)
        case day(DaySelection)
        case settings
    }

    private(set) var events: [Event] = []

    func showRate(_ rate: RateSelection) { events.append(.rate(rate)) }

    func showDay(_ day: DaySelection) { events.append(.day(day)) }

    func showSettings() { events.append(.settings) }
}
