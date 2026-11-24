@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
struct CoordinatorTests {
    @Test(arguments: [
        Scenario(actions: [.push(1), .push(2)], expectedPath: [1, 2]),
        Scenario(actions: [.push(1), .push(1)], expectedPath: [1, 1]),
        Scenario(actions: [.push(1), .push(2), .pop], expectedPath: [1]),
        Scenario(actions: [.pop], expectedPath: []),
        Scenario(actions: [.push(1), .push(2), .popToRoot], expectedPath: []),
        Scenario(actions: [.popToRoot], expectedPath: []),
        Scenario(actions: [.push(1), .popToRoot, .push(2)], expectedPath: [2])
    ])
    func updatesPath(_ scenario: Scenario) {
        let sut = CoordinatorStub()

        scenario.actions.forEach { perform($0, on: sut) }

        #expect(sut.path == scenario.expectedPath)
    }

    @Test(arguments: [Action.push(3), .pop, .popToRoot])
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

// MARK: - Test data

extension CoordinatorTests {
    enum Action {
        case push(Int), pop, popToRoot
    }

    struct Scenario {
        let actions: [Action]
        let expectedPath: [Int]
    }
}
