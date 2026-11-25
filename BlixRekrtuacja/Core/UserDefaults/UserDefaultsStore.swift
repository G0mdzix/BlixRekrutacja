import Foundation
import OSLog

struct UserDefaultsStore: KeyValueStore {
    let defaults: UserDefaults

    func value<Value>(for key: StorageKey<Value>) -> Value {
        guard let data = defaults.data(forKey: key.name) else { return key.defaultValue }
        do {
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            Logger.storage.error("Failed to read \(key.name, privacy: .public): \(error, privacy: .public)")
            return key.defaultValue
        }
    }

    func set<Value>(_ value: Value, for key: StorageKey<Value>) throws {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key.name)
        } catch {
            Logger.storage.error("Failed to save \(key.name, privacy: .public): \(error, privacy: .public)")
            throw AppError.storage
        }
    }
}

extension UserDefaultsStore {
    static func isolated() -> Self {
        guard let defaults = UserDefaults(suiteName: UUID().uuidString) else {
            preconditionFailure("Could not create an isolated UserDefaults suite")
        }
        return Self(defaults: defaults)
    }
}
