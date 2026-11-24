import SnapshotTesting
import SwiftUI

@MainActor
func assertSnapshots(
    of view: some View,
    layout: SwiftUISnapshotLayout = .device(config: .iPhone13),
    fileID: StaticString = #fileID,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    for style in [UIUserInterfaceStyle.light, .dark] {
        for size in [UIContentSizeCategory.large, .accessibilityExtraExtraExtraLarge] {
            let traits = UITraitCollection { $0.userInterfaceStyle = style; $0.preferredContentSizeCategory = size }
            assertSnapshot(
                of: view,
                as: .image(layout: layout, traits: traits),
                named: "\(style == .dark ? "dark" : "light")-\(size == .large ? "large" : "ax5")",
                fileID: fileID,
                file: file,
                testName: testName,
                line: line,
                column: column
            )
        }
    }
}
