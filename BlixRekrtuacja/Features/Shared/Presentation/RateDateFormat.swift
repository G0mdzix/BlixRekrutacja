import Foundation

enum RateDateFormat {
    static let day = Date.FormatStyle(timeZone: .gmt).weekday(.wide).day().month(.wide)
    static let dayWithYear = day.year()
}
