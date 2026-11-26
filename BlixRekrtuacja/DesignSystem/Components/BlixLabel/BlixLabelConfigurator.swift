import SwiftUI

struct BlixLabelConfigurator {
    enum Content {
        case localized(LocalizedStringResource)
        case verbatim(String)
        /// Below 1 the digits are significant, so tiny rates (BTC, XAU) don't round to zero.
        case number(Decimal, fractionLength: Int)
        case percent(Decimal, fractionLength: Int)
        case date(Date, Date.FormatStyle)

        var text: Text {
            switch self {
            case .localized(let resource): Text(resource)
            case .verbatim(let string): Text(verbatim: string)
            case let .number(value, digits):
                Text(value, format: .number.precision(
                    value.magnitude < 1 ? .significantDigits(digits) : .fractionLength(digits)
                ))
            case let .percent(value, digits): Text(value, format: .percent.precision(.fractionLength(digits)))
            case let .date(value, format): Text(value, format: format)
            }
        }
    }

    enum Style {
        case primary
        case secondary
        case positive
        case negative
        case accent
        /// Text on a `brandPrimary` fill: dark in both appearances, because the fill is light in both.
        case onBrand

        var color: Color {
            switch self {
            case .primary: .textPrimary
            case .secondary: .textSecondary
            case .positive: .textPositive
            case .negative: .textNegative
            case .accent: .textPositive
            case .onBrand: .textOnBrand
            }
        }
    }

    let text: Content
    var style = Style.primary
    var typography = Typography.body
    var weight: Font.Weight?
    var icon: SFSymbol?
    var alignment = TextAlignment.leading
    var monospacedDigits = false
}
