@testable import BlixRekrtuacja
import Foundation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct MainCoordinatorTests {
    let preferences = UserPreferences.isolated()
    let clipboard = ClipboardSpy()
    let sut: MainCoordinator

    init() {
        sut = MainCoordinator(
            repository: RatesRepositorySpy(),
            preferences: preferences,
            dates: RatesSamples.dates,
            clipboard: clipboard
        )
    }

    @Test(arguments: RootIntent.allCases)
    func rootIntentsPushTheirScreenWithItsData(_ intent: RootIntent) async throws {
        await sut.root.start()
        let day = try #require(sut.root.days.first)

        try perform(intent, on: day)

        let route = try #require(sut.path.last)
        #expect(sut.path.count == 1)
        switch intent {
        case .tapRate: #expect(route.rateDetail?.rate.code == sut.root.rowConfigurators(day).first?.code)
        case .showAll: #expect(route.dayRates?.results.rows.count == day.rates.count)
        case .openSettings: #expect(route.settings != nil)
        }
    }

    @Test func settingsChangeTheSharedPreferences() throws {
        sut.showSettings()

        try #require(sut.path.last?.settings).appearanceRowConfigurator(.dark).action()

        #expect(preferences.appearance == .dark)
    }

    @Test func pushingTheSameScreenTwiceKeepsTwoRoutes() {
        sut.showSettings()
        sut.showSettings()

        #expect(sut.path.count == 2)
        #expect(sut.path[0] != sut.path[1])
    }

    @Test func rateDetailCopiesToTheClipboard() throws {
        let rate = RatesSamples.selection("PLN", "złoty polski", "4.459811", change: nil)
        sut.showRate(rate)

        try #require(sut.path.last?.rateDetail).copyRate()

        #expect(clipboard.copied == ["4.459811"])
    }

    @Test func choosingARateOnTheDayScreenPushesItsDetail() throws {
        sut.showDay(RatesSamples.threeCurrencyDay)
        let day = try #require(sut.path.last?.dayRates)
        day.query = "PLN"

        let tap = try #require(day.results.rows.first?.action)
        tap()

        #expect(sut.path.count == 2)
        #expect(sut.path.last?.rateDetail?.rate.code == "PLN")
    }

    // MARK: - Helpers

    private func perform(_ intent: RootIntent, on day: DailyRates) throws {
        switch intent {
        case .tapRate:
            let tap = try #require(sut.root.rowConfigurators(day).first?.action)
            tap()
        case .showAll:
            let showAll = try #require(sut.root.showAllButtonConfigurator(day))
            showAll.action()
        case .openSettings:
            sut.root.openSettings()
        }
    }
}
