@testable import BlixRekrtuacja
import Foundation
import Testing

@Suite(.tags(.unit, .storage))
struct UserDefaultsStoreTests {
    @Test(arguments: Self.valueScenarios)
    func readsLastSavedValueOrDefault(_ scenario: Scenario) throws {
        let sut = UserDefaultsStore.isolated()

        try scenario.actions.forEach { try perform($0, on: sut) }

        #expect(sut.value(for: .sample) == scenario.expectedValue)
    }

    @Test func keepsPreviousValueWhenSaveFails() throws {
        let sut = UserDefaultsStore.isolated()
        try sut.set(1, for: .unencodable)

        #expect(throws: AppError.storage) { try sut.set(Double.infinity, for: .unencodable) }

        #expect(sut.value(for: .unencodable) == 1)
    }

    // MARK: - Helpers

    private func perform(_ action: Action, on store: UserDefaultsStore) throws {
        switch action {
        case .save(let value): try store.set(value, for: .sample)
        case .corruptStoredData: store.defaults.set(Data("not json".utf8), forKey: StorageKey.sample.name)
        }
    }
}
