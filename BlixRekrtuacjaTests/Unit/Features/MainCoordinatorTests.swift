@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct MainCoordinatorTests {
    @Test(arguments: Self.rootIntents)
    func rootIntentsPushTheirScreenWithItsData(_ scenario: RootIntentScenario) async throws {
        let (sut, _) = Self.makeSUT()
        await sut.root.start()
        let day = try #require(sut.root.days.first)

        try Self.perform(scenario.intent, on: sut.root, day: day)

        let route = try #require(sut.path.last)
        #expect(sut.path.count == 1)
        switch scenario.intent {
        case .tapRate: #expect(route.rateDetail?.rate.code == sut.root.rowConfigurators(day).first?.code)
        case .showAll: #expect(route.dayRates?.rowConfigurators(matching: "").count == day.rates.count)
        case .openSettings: #expect(route.settings != nil)
        }
    }

    @Test func settingsChangeTheSharedPreferences() throws {
        let (sut, preferences) = Self.makeSUT()
        sut.showSettings()

        let settings = try #require(sut.path.last?.settings)
        settings.appearanceRowConfigurator(.dark).action()

        #expect(preferences.appearance == .dark)
    }

    @Test func pushingTheSameScreenTwiceKeepsTwoRoutes() {
        let (sut, _) = Self.makeSUT()

        sut.showSettings()
        sut.showSettings()

        #expect(sut.path.count == 2)
        let first = sut.path[0]
        #expect(sut.path[0] == first)
        #expect(sut.path[1] != first)
    }

    @Test func showRatePushesADetailThatCopiesThroughTheApp() throws {
        let copied = OSAllocatedUnfairLock<String?>(initialState: nil)
        let (sut, _) = Self.makeSUT { text in copied.withLock { $0 = text } }
        let rate = RatesSamples.selection("PLN", "złoty polski", "4.459811", change: nil)

        sut.showRate(rate)

        let detail = try #require(sut.path.last?.rateDetail)
        detail.copyRate()
        #expect(detail.rate == rate)
        #expect(copied.withLock { $0 } == "4.459811")
    }

    @Test func choosingARateOnTheDayScreenPushesItsDetail() throws {
        let (sut, _) = Self.makeSUT()
        sut.showDay(RatesSamples.threeCurrencyDay)

        let day = try #require(sut.path.last?.dayRates)
        let action = try #require(day.rowConfigurators(matching: "PLN").first?.action)
        action()

        #expect(sut.path.count == 2)
        #expect(sut.path.last?.rateDetail?.rate.code == "PLN")
    }

    // MARK: - Helpers

    private static func makeSUT(
        copy: @escaping @MainActor (String) -> Void = { _ in }
    ) -> (MainCoordinator, UserPreferences) {
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        let sut = MainCoordinator(
            repository: RatesRepositoryStub { RatesSamples.market(on: RatesSamples.wednesday) },
            preferences: preferences,
            copy: copy
        )
        return (sut, preferences)
    }

    private static func perform(_ intent: RootIntent, on root: RatesViewModel, day: DailyRates) throws {
        switch intent {
        case .tapRate:
            let action = try #require(root.rowConfigurators(day).first?.action)
            action()
        case .showAll:
            let showAll = try #require(root.showAllButtonConfigurator(day))
            showAll.action()
        case .openSettings:
            root.openSettings()
        }
    }
}
