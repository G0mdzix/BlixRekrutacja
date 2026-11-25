/// Every pushed screen, carrying the ViewModel the coordinator created for it.
enum MainRoute: Hashable {
    case day(DayRatesViewModel)
    case rate(RateDetailViewModel)
    case settings(SettingsViewModel)
}
