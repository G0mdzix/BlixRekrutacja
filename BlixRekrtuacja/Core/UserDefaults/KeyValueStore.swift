protocol KeyValueStore {
    func value<Value>(for key: StorageKey<Value>) -> Value
    func set<Value>(_ value: Value, for key: StorageKey<Value>) throws
}
