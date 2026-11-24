import SnapshotTesting
import SwiftUI

/// Snapshots a view in light/dark × large/accessibility5 (4 images).
/// Components: pass `view.frame(width: 390)` with `layout: .sizeThatFits`. Screens: default `.device`.
/// Record: prefix the test command with `TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all`.
@MainActor
func assertSnapshots(
    of view: some View,
    layout: SwiftUISnapshotLayout = .device(config: .iPhone13),
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    for style in [UIUserInterfaceStyle.light, .dark] {
        for size in [UIContentSizeCategory.large, .accessibilityExtraExtraExtraLarge] {
            let traits = UITraitCollection { $0.userInterfaceStyle = style; $0.preferredContentSizeCategory = size }
            assertSnapshot(
                of: view,
                as: .image(layout: layout, traits: traits),
                named: "\(style == .dark ? "dark" : "light")-\(size == .large ? "large" : "ax5")",
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
