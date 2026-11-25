import SwiftUI

struct BlixLabelConfigurator {
    enum Content {
        case localized(LocalizedStringResource)
        case verbatim(String)

        var text: Text {
            switch self {
            case .localized(let resource): Text(resource)
            case .verbatim(let string): Text(verbatim: string)
            }
        }
    }

    enum Style {
        case primary
        case secondary

        var color: HierarchicalShapeStyle {
            switch self {
            case .primary: .primary
            case .secondary: .secondary
            }
        }
    }

    let text: Content
    var style = Style.primary
    var typography = Typography.body
    var weight: Font.Weight?
    var icon: SFSymbol?
    var alignment = TextAlignment.leading
}
