extension CoordinatorTests {
    enum Action {
        case push(Int), pop, popToRoot
    }

    struct Scenario {
        let actions: [Action]
        let expectedPath: [Int]
    }

    nonisolated static let pathScenarios: [Scenario] = [
        Scenario(actions: [.push(1), .push(2)], expectedPath: [1, 2]),
        Scenario(actions: [.push(1), .push(1)], expectedPath: [1, 1]),
        Scenario(actions: [.push(1), .push(2), .pop], expectedPath: [1]),
        Scenario(actions: [.pop], expectedPath: []),
        Scenario(actions: [.push(1), .push(2), .popToRoot], expectedPath: []),
        Scenario(actions: [.popToRoot], expectedPath: []),
        Scenario(actions: [.push(1), .popToRoot, .push(2)], expectedPath: [2])
    ]

    nonisolated static let pathChangingActions: [Action] = [.push(3), .pop, .popToRoot]
}
