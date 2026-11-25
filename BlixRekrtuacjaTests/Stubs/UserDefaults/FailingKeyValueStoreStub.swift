@testable import BlixRekrtuacja

struct FailingKeyValueStoreStub: KeyValueStore {
    func value<Value>(for key: StorageKey<Value>) -> Value { key.defaultValue }
    func set<Value>(_ value: Value, for key: StorageKey<Value>) throws { throw AppError.storage }
}
