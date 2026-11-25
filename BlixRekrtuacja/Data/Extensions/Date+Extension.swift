import Foundation

// MARK: - Fixer
extension Date.ISO8601FormatStyle {
    /// `2026-11-21` in UTC: the format of Fixer's paths and of its `date` field.
    static let fixerDay = Self().year().month().day()
}
