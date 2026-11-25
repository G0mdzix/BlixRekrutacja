struct StorageKey<Value: Codable & Sendable>: Sendable {
    let name: String
    let defaultValue: Value
}
