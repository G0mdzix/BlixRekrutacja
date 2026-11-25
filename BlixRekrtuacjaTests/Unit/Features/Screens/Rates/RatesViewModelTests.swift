@testable import BlixRekrtuacja
import Foundation
import Testing

@MainActor
@Suite(.tags(.unit, .feature))
struct RatesViewModelTests {
    let repository = RatesRepositorySpy { Self.rates(on: $0.day ?? RatesSamples.wednesday) }
    let navigator = MainNavigatingSpy()
    let sut: RatesViewModel

    init() {
        sut = RatesViewModel(
            repository: repository,
            preferences: .isolated(language: .english),
            dates: RatesSamples.dates,
            navigator: navigator
        )
    }

    @Test(arguments: Self.starts)
    func startsWithLatestAndThePreviousWorkingDay(_ scenario: StartScenario) async {
        repository.answer = { Self.rates(on: $0.day ?? scenario.latestDay) }

        await sut.start()

        #expect(sut.days.map(\.day) == scenario.expectedDays)
        #expect(repository.requests == [.latest, .day(scenario.expectedDays[1])])
        #expect(sut.footer == .loading)
    }

    @Test(arguments: Self.firstLoadFailures)
    func showsAnEmptyStateWhenNothingLoads(_ scenario: FirstLoadScenario) async {
        repository.answer = { _ in throw scenario.error }

        await sut.start()

        #expect(sut.footer == nil)
        #expect(sut.content.emptyState?.icon == scenario.expectedIcon)
        #expect(sut.content.emptyState?.badge == scenario.expectedBadge)
        #expect((sut.content.retry != nil) == scenario.offersRetry)
    }

    @Test(arguments: Self.reappearances)
    func appearingAgainDoesNotReload(_ scenario: ReappearScenario) async {
        if let error = scenario.error { repository.answer = { _ in throw error } }
        await sut.start()

        await sut.start()

        #expect(repository.requests == scenario.expectedCalls)
    }

    @Test func footerWaitsForARetryAfterAFailure() async {
        repository.answer = { request in
            guard request == .latest else { throw AppError.offline }
            return Self.rates(on: RatesSamples.wednesday)
        }
        await sut.start()

        await sut.footerAppeared()

        #expect(repository.requests == [.latest, .day(RatesSamples.tuesday)])
    }

    @Test func movesOnWhenADayComesBackAgain() async {
        repository.answer = { _ in Self.rates(on: RatesSamples.wednesday) }
        await sut.start()

        await sut.footerAppeared()

        #expect(sut.days.map(\.day) == [RatesSamples.wednesday])
        #expect(repository.requests.last == .day(Self.monday))
        #expect(sut.nextDay == RatesSamples.friday)
    }

    @Test func pagesPastAHolidayThatAnswersAnEarlierDay() async {
        repository.answer = { request in
            Self.rates(on: request.day == RatesSamples.tuesday ? Self.monday : request.day ?? RatesSamples.wednesday)
        }
        await sut.start()

        await sut.footerAppeared()

        #expect(sut.days.map(\.day) == [RatesSamples.wednesday, Self.monday, RatesSamples.friday])
        #expect(repository.requests == [.latest, .day(RatesSamples.tuesday), .day(RatesSamples.friday)])
    }

    @Test(arguments: Self.olderDayFailures)
    func showsTheOlderDayFailureInTheFooter(_ scenario: OlderDayFailureScenario) async {
        repository.answer = { request in
            guard request == .latest else { throw scenario.error }
            return Self.rates(on: RatesSamples.wednesday)
        }

        await sut.start()
        await sut.loadNextDay()

        #expect(sut.days.count == 1)
        #expect(repository.requests.count == scenario.expectedCalls)
        guard case .failed(let error) = sut.footer else {
            Issue.record("Expected a failed footer, got \(String(describing: sut.footer))")
            return
        }
        #expect(error == scenario.error)
        #expect((sut.messageCardConfigurator(error).button != nil) == scenario.offersRetry)
    }

    @Test(arguments: Self.retries)
    func retryClearsTheErrorWhenItSucceedsOrIsCancelled(_ scenario: RetryScenario) async {
        var outcomes = scenario.olderDayOutcomes[...]
        repository.answer = { request in
            guard let day = request.day else { return Self.rates(on: RatesSamples.wednesday) }
            switch outcomes.popFirst() {
            case .fails: throw AppError.offline
            case .isCancelled: throw CancellationError()
            case .loads, nil: return Self.rates(on: day)
            }
        }
        await sut.start()

        for _ in scenario.olderDayOutcomes.dropFirst() { await sut.loadNextDay() }

        #expect(sut.days.count == scenario.expectedDays)
        #expect(sut.error == scenario.expectedError)
    }

    @Test func autoLoadsUpToTheLimitThenOffersAButton() async {
        await sut.start()

        for _ in 0...RatesViewModel.Paging.autoLoadedDays { await sut.footerAppeared() }

        #expect(sut.days.count == RatesViewModel.Paging.autoLoadedDays)
        #expect(sut.footer == .loadOlderButton)
    }

    @Test(arguments: Self.rowScenarios)
    func showsPopularCurrenciesWithTheirChange(_ scenario: RowScenario) async {
        await sut.start()

        let rows = sut.rowConfigurators(sut.days[scenario.dayIndex])

        #expect(rows.map(\.code) == scenario.expectedCodes)
        #expect(rows.first { $0.code == "PLN" }?.change == scenario.expectedPLNChange)
        #expect(rows.first { $0.code == "JPY" }?.change == nil)
    }

    @Test func showAllOpensTheDayWithEveryCurrency() async throws {
        await sut.start()

        let showAll = try #require(sut.showAllButtonConfigurator(sut.days[0]))
        showAll.action()

        guard case .day(let day) = try #require(navigator.events.first) else {
            Issue.record("Expected the day, got \(navigator.events)")
            return
        }
        #expect(day.rates.map(\.code) == ["AUD", "CHF", "GBP", "JPY", "PLN", "USD"])
        #expect(day.rates.first { $0.code == "PLN" } == Self.expectedPLNSelection)
    }

    @Test func hidesShowAllWhenEveryCurrencyIsShown() async {
        repository.answer = { RatesSamples.rates(on: $0.day ?? RatesSamples.wednesday) }
        await sut.start()

        #expect(sut.showAllButtonConfigurator(sut.days[0]) == nil)
    }

    @Test func tappingARowOpensThatRate() async throws {
        await sut.start()

        let tap = try #require(sut.rowConfigurators(sut.days[0]).first { $0.code == "PLN" }?.action)
        tap()

        #expect(navigator.events == [.rate(Self.expectedPLNSelection)])
    }

    @Test(arguments: Self.headers)
    func marksTodayAndClosedDays(_ scenario: HeaderScenario) async {
        repository.answer = { Self.rates(on: $0.day ?? scenario.latestDay) }
        await sut.start()

        let header = sut.headerConfigurator(sut.days[0])

        #expect((header.badge != nil) == scenario.expectsTodayBadge)
    }

    @Test func settingsButtonOpensSettings() {
        sut.openSettings()

        #expect(navigator.events == [.settings])
    }
}
