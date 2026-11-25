extension StorageKey where Value == Appearance {
    static var appearance: Self { Self(name: "appearance", defaultValue: .system) }
}
