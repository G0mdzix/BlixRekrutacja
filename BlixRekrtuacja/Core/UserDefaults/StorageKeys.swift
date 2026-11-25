extension StorageKey where Value == Appearance {
    static var appearance: Self { Self(name: "appearance", defaultValue: .system) }
}

extension StorageKey where Value == Language {
    static var language: Self { Self(name: "language", defaultValue: .system) }
}
