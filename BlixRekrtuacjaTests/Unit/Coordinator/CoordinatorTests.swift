@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .navigation))
struct CoordinatorTests {
    @Test(arguments: Self.pathScenarios)
    func updatesPath(_ scenario: Scenario) {
        let sut = CoordinatorStub()

        scenario.actions.forEach { perform($0, on: sut) }

        #expect(sut.path == scenario.expectedPath)
    }

    @Test(arguments: Self.pathChangingActions)
    func notifiesObserversWhenPathChanges(_ action: Action) async {
        let sut = CoordinatorStub()
        sut.path = [1, 2]

        await confirmation { pathChanged in
            withObservationTracking { _ = sut.path } onChange: { pathChanged() }
            perform(action, on: sut)
        }
    }

    // MARK: - Helpers

    private func perform(_ action: Action, on coordinator: CoordinatorStub) {
        switch action {
        case .push(let route): coordinator.push(route)
        case .pop: coordinator.pop()
        case .popToRoot: coordinator.popToRoot()
        }
    }
}
