import Foundation

/// Days in UTC, the time zone of the rates. The ECB publishes no rates on Saturdays and Sundays.
enum BusinessDays {
    static func day(containing date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func previous(before date: Date) -> Date {
        var candidate = day(containing: date)
        repeat {
            guard let earlier = calendar.date(byAdding: .day, value: -1, to: candidate) else { break }
            candidate = earlier
        } while isWeekend(candidate)
        return candidate
    }

    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar
    }()

    private static func isWeekend(_ day: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: day)
        return weekday == Weekday.sunday || weekday == Weekday.saturday
    }
}

// MARK: - Constants

private enum Weekday {
    static let sunday = 1
    static let saturday = 7
}
