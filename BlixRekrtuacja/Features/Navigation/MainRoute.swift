enum MainRoute: Hashable {
    case day(DayRatesViewModel)
    case rate(RateDetailViewModel)
    case settings(SettingsViewModel)

    nonisolated static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }

    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(id) }

    nonisolated private var id: ObjectIdentifier {
        switch self {
        case .day(let viewModel): ObjectIdentifier(viewModel)
        case .rate(let viewModel): ObjectIdentifier(viewModel)
        case .settings(let viewModel): ObjectIdentifier(viewModel)
        }
    }
}
