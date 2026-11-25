@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .storage))
struct UserDefaultsStoreTests {
    @Test(arguments: Self.valueScenarios)
    func readsLastSavedValueOrDefault(_ scenario: Scenario) {
        let sut = UserDefaultsStore.isolated()

        scenario.actions.forEach { perform($0, on: sut) }

        #expect(sut.value(for: .sample) == scenario.expectedValue)
    }

    @Test func keepsPreviousValueWhenSaveFails() {
        let sut = UserDefaultsStore.isolated()
        sut.set(1, for: .unencodable)

        sut.set(Double.infinity, for: .unencodable)

        #expect(sut.value(for: .unencodable) == 1)
    }

    // MARK: - Helpers

    private func perform(_ action: Action, on store: UserDefaultsStore) {
        switch action {
        case .save(let value): store.set(value, for: .sample)
        case .corruptStoredData: store.defaults.set(Data("not json".utf8), forKey: StorageKey.sample.name)
        }
    }
}
