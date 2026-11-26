import SnapshotTesting
import SwiftUI

struct SnapshotConfigurator {
    enum InterfaceStyle: String, CaseIterable {
        case light
        case dark

        var userInterfaceStyle: UIUserInterfaceStyle { self == .dark ? .dark : .light }
    }

    enum TextSize: String {
        case extraSmall = "xSmall"
        case large
        case accessibility5 = "ax5"

        var dynamicTypeSize: DynamicTypeSize {
            switch self {
            case .extraSmall: .xSmall
            case .large: .large
            case .accessibility5: .accessibility5
            }
        }
    }

    enum Layout {
        case screen
        case component(width: CGFloat = 390)
        case fixed(width: CGFloat, height: CGFloat)

        var width: CGFloat? {
            if case .component(let width) = self { width } else { nil }
        }

        var snapshotLayout: SwiftUISnapshotLayout {
            switch self {
            case .screen: .device(config: .iPhone13)
            case .component: .sizeThatFits
            case let .fixed(width, height): .fixed(width: width, height: height)
            }
        }
    }

    var interfaceStyles = InterfaceStyle.allCases
    var textSizes: [TextSize] = [.large]
    var layout = Layout.screen
    /// Renders through a real window: Liquid Glass bars pick their text color from what is behind them, which an
    /// offscreen render cannot sample (the light title and toolbar came out white on white). Live animations,
    /// such as a spinner, are then caught mid-frame, so screens are snapshotted in settled states only.
    var drawsInWindow = false

    static let screen = Self(drawsInWindow: true)
    static let component = Self(textSizes: [.extraSmall, .large, .accessibility5], layout: .component())

    func layout(_ layout: Layout) -> Self {
        var copy = self
        copy.layout = layout
        return copy
    }

    @MainActor
    func traits(_ style: InterfaceStyle, _ size: TextSize) -> UITraitCollection {
        UITraitCollection {
            $0.userInterfaceStyle = style.userInterfaceStyle
            $0.preferredContentSizeCategory = UIContentSizeCategory(size.dynamicTypeSize)
        }
    }
}
