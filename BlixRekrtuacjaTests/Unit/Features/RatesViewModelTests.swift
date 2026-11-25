@testable import BlixRekrtuacja
import Foundation
import os
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct RatesViewModelTests {
    @Test(arguments: Self.starts)
    func startsWithLatestAndThePreviousWorkingDay(_ scenario: StartScenario) async {
        let (sut, calls) = Self.makeSUT(latestDay: scenario.latestDay)

        await sut.start()

        #expect(sut.days.map(\.day) == scenario.expectedDays)
        #expect(calls.withLock { $0 } == [.latest, .day(scenario.expectedDays[1])])
        #expect(sut.footer == .loading)
    }

    @Test(arguments: Self.firstLoadFailures)
    func showsAnEmptyStateWhenNothingLoads(_ scenario: FirstLoadScenario) async {
        let (sut, _) = Self.makeSUT { _ in throw scenario.error }

        await sut.start()

        let emptyState = sut.emptyStateConfigurator
        #expect(sut.days.isEmpty)
        #expect(sut.footer == nil)
        #expect(emptyState?.icon == scenario.expectedIcon)
        #expect(emptyState?.badge == scenario.expectedBadge)
        #expect((sut.emptyStateButtonConfigurator != nil) == scenario.offersRetry)
    }

    @Test(arguments: Self.reappearances)
    func appearingAgainNeitherReloadsNorRetries(_ scenario: ReappearScenario) async {
        let (sut, calls) = Self.makeSUT { request in
            if let error = scenario.error { throw error }
            return Self.rates(on: request.day ?? RatesSamples.wednesday)
        }
        await sut.start()

        await sut.start()

        #expect(calls.withLock { $0 } == scenario.expectedCalls)
        #expect(sut.failedRetries == 0)
    }

    @Test func footerWaitsForARetryAfterAFailure() async {
        let (sut, calls) = Self.makeSUT { request in
            guard request == .latest else { throw AppError.offline }
            return Self.rates(on: RatesSamples.wednesday)
        }
        await sut.start()

        await sut.footerAppeared()

        #expect(calls.withLock { $0 } == [.latest, .day(RatesSamples.tuesday)])
    }

    @Test func movesOnWhenADayComesBackAgain() async {
        let (sut, calls) = Self.makeSUT { _ in Self.rates(on: RatesSamples.wednesday) }
        await sut.start()

        await sut.footerAppeared()

        #expect(sut.days.map(\.day) == [RatesSamples.wednesday])
        #expect(calls.withLock { $0 }.last == .day(Self.monday))
    }

    @Test(arguments: Self.olderDayFailures)
    func showsTheOlderDayFailureInTheFooter(_ scenario: OlderDayFailureScenario) async {
        let (sut, calls) = Self.makeSUT { request in
            guard request == .latest else { throw scenario.error }
            return Self.rates(on: RatesSamples.wednesday)
        }

        await sut.start()
        await sut.loadNextDay()

        #expect(sut.days.count == 1)
        #expect(sut.footer == scenario.expectedFooter)
        #expect(calls.withLock { $0 }.count == scenario.expectedCalls)
        #expect((sut.failedCardConfigurator(scenario.error).button != nil) == scenario.offersRetry)
    }

    @Test(arguments: Self.retries)
    func retryKeepsTheErrorUntilItSucceeds(_ scenario: RetryScenario) async {
        let attempt = OSAllocatedUnfairLock(initialState: 0)
        let (sut, _) = Self.makeSUT { request in
            guard let day = request.day else { return Self.rates(on: RatesSamples.wednesday) }
            let index = attempt.withLock { count in
                defer { count += 1 }
                return count
            }
            switch scenario.olderDayOutcomes[index] {
            case .loads: return Self.rates(on: day)
            case .fails: throw AppError.offline
            case .isCancelled: throw CancellationError()
            }
        }
        await sut.start()

        for _ in scenario.olderDayOutcomes.dropFirst() { await sut.loadNextDay() }

        #expect(sut.days.count == scenario.expectedDays)
        #expect(sut.error == scenario.expectedError)
        #expect(sut.failedRetries == scenario.expectedFailedRetries)
    }

    @Test func autoLoadsUpToTheLimitThenOffersAButton() async {
        let (sut, _) = Self.makeSUT()
        await sut.start()

        for _ in 0...RatesViewModel.Paging.autoLoadedDays { await sut.footerAppeared() }

        #expect(sut.days.count == RatesViewModel.Paging.autoLoadedDays)
        #expect(sut.footer == .loadOlderButton)
    }

    @Test(arguments: Self.rowScenarios)
    func showsPopularCurrenciesWithTheirChange(_ scenario: RowScenario) async {
        let (sut, _) = Self.makeSUT()
        await sut.start()

        let rows = sut.rowConfigurators(sut.days[scenario.dayIndex])

        #expect(rows.map(\.code) == scenario.expectedCodes)
        #expect(rows.first { $0.code == "PLN" }?.change == scenario.expectedPLNChange)
    }

    @Test func showAllOpensTheDayWithEveryCurrency() async throws {
        let shown = OSAllocatedUnfairLock<DaySelection?>(initialState: nil)
        let show: @MainActor (DaySelection) -> Void = { day in shown.withLock { $0 = day } }
        let (sut, _) = Self.makeSUT(onShowDay: show)
        await sut.start()

        try #require(sut.showAllButtonConfigurator(sut.days[0])).action()

        let day = try #require(shown.withLock { $0 })
        #expect(day.day == RatesSamples.wednesday)
        #expect(day.rates.map(\.code) == ["AUD", "CHF", "GBP", "JPY", "PLN", "USD"])
        #expect(day.rates.first { $0.code == "PLN" } == Self.expectedPLNSelection)
    }

    @Test func hidesShowAllWhenEveryCurrencyIsShown() async {
        let (sut, _) = Self.makeSUT { RatesSamples.rates(on: $0.day ?? RatesSamples.wednesday) }
        await sut.start()

        #expect(sut.showAllButtonConfigurator(sut.days[0]) == nil)
    }

    @Test func tappingARowSelectsThatRate() async throws {
        let selected = OSAllocatedUnfairLock<RateSelection?>(initialState: nil)
        let select: @MainActor (RateSelection) -> Void = { selection in selected.withLock { $0 = selection } }
        let (sut, _) = Self.makeSUT(onSelectRate: select)
        await sut.start()

        let row = try #require(sut.rowConfigurators(sut.days[0]).first { $0.code == "PLN" })
        row.action?()

        #expect(selected.withLock { $0 } == Self.expectedPLNSelection)
    }

    @Test(arguments: Self.headers)
    func marksTodayAndClosedDays(_ scenario: HeaderScenario) async {
        let (sut, _) = Self.makeSUT(latestDay: scenario.latestDay)
        await sut.start()

        let header = sut.headerConfigurator(sut.days[0])

        #expect((header.badge != nil) == scenario.expectsTodayBadge)
    }

    @Test func settingsButtonOpensSettings() async {
        await confirmation(expectedCount: 1) { opened in
            let open: @MainActor () -> Void = { opened() }
            let (sut, _) = Self.makeSUT(onOpenSettings: open)

            sut.openSettings()
        }
    }

    // MARK: - Helpers

    private static func makeSUT(
        latestDay: Date = RatesSamples.wednesday,
        answer: (@Sendable (RatesRequest) throws -> DailyRates)? = nil,
        onSelectRate: @escaping @MainActor (RateSelection) -> Void = { _ in },
        onShowDay: @escaping @MainActor (DaySelection) -> Void = { _ in },
        onOpenSettings: @escaping @MainActor () -> Void = {}
    ) -> (RatesViewModel, OSAllocatedUnfairLock<[RatesRequest]>) {
        let calls = OSAllocatedUnfairLock<[RatesRequest]>(initialState: [])
        let repository = recordingRepository(calls: calls, answer: answer ?? { rates(on: $0.day ?? latestDay) })
        let preferences = UserPreferences(store: UserDefaultsStore.isolated())
        try? preferences.set(Language.english)
        let sut = RatesViewModel(
            repository: repository,
            preferences: preferences,
            now: { RatesSamples.wednesdayNoon },
            timeZone: .gmt,
            onSelectRate: onSelectRate,
            onShowDay: onShowDay,
            onOpenSettings: onOpenSettings
        )
        return (sut, calls)
    }

    private static func recordingRepository(
        calls: OSAllocatedUnfairLock<[RatesRequest]>,
        answer: @escaping @Sendable (RatesRequest) throws -> DailyRates
    ) -> RatesRepositoryStub {
        RatesRepositoryStub {
            calls.withLock { $0.append(.latest) }
            return try answer(.latest)
        } onRates: { day in
            calls.withLock { $0.append(.day(day)) }
            return try answer(.day(day))
        }
    }
}
