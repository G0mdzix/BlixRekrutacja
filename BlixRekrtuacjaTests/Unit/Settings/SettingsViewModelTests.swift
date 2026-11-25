@testable import BlixRekrtuacja
import Observation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct SettingsViewModelTests {
    @Test(arguments: Self.savedAppearances)
    func loadsSavedAppearance(_ scenario: LoadScenario) throws {
        let store = try Self.makeStore(saved: scenario.saved)

        let sut = SettingsViewModel(store: store)

        #expect(sut.appearance == scenario.expected)
    }

    @Test(arguments: Self.taps)
    func tappingRowSelectsAndSavesAppearance(_ scenario: TapScenario) throws {
        let store = try Self.makeStore(saved: scenario.saved)
        let sut = SettingsViewModel(store: store)

        sut.appearanceRowConfigurator(scenario.tapped).action()

        #expect(sut.appearance == scenario.tapped)
        #expect(store.value(for: .appearance) == scenario.tapped)
        #expect(Appearance.allCases.filter { sut.appearanceRowConfigurator($0).isSelected } == [scenario.tapped])
    }

    @Test(arguments: Self.failingTaps)
    func reportsErrorOnlyWhenSavingFails(_ scenario: FailingTapScenario) {
        let sut = SettingsViewModel(store: FailingKeyValueStoreStub())

        sut.appearanceRowConfigurator(scenario.tapped).action()

        #expect(sut.appearance == .system)
        #expect(sut.error == scenario.expectedError)
    }

    @Test func clearsErrorWhenDismissed() throws {
        let sut = SettingsViewModel(store: FailingKeyValueStoreStub())
        sut.appearanceRowConfigurator(.dark).action()
        try #require(sut.error == .storage)

        sut.dismissError()

        #expect(sut.error == nil)
    }

    @Test(arguments: Self.observedChanges)
    func notifiesObserversWhenStateChanges(_ change: ObservedChange) async {
        let sut = Self.makeSUT(for: change)

        await confirmation { changed in
            withObservationTracking { read(change, from: sut) } onChange: { changed() }
            perform(change, on: sut)
        }
    }

    // MARK: - Helpers

    private static func makeStore(saved: Appearance?) throws -> UserDefaultsStore {
        let store = UserDefaultsStore.isolated()
        if let saved { try store.set(saved, for: .appearance) }
        return store
    }

    private static func makeSUT(for change: ObservedChange) -> SettingsViewModel {
        switch change {
        case .appearance: SettingsViewModel(store: UserDefaultsStore.isolated())
        case .errorShown: SettingsViewModel(store: FailingKeyValueStoreStub())
        case .errorDismissed: Self.makeSUTWithError()
        }
    }

    private static func makeSUTWithError() -> SettingsViewModel {
        let sut = SettingsViewModel(store: FailingKeyValueStoreStub())
        sut.appearanceRowConfigurator(.dark).action()
        return sut
    }

    private func read(_ change: ObservedChange, from sut: SettingsViewModel) {
        switch change {
        case .appearance: _ = sut.appearance
        case .errorShown, .errorDismissed: _ = sut.error
        }
    }

    private func perform(_ change: ObservedChange, on sut: SettingsViewModel) {
        switch change {
        case .appearance, .errorShown: sut.appearanceRowConfigurator(.dark).action()
        case .errorDismissed: sut.dismissError()
        }
    }
}
