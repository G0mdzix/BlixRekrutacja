import Foundation
import SnapshotTesting
import SwiftUI
import Testing

@MainActor
func assertSnapshots(
    of view: some View,
    named name: String,
    configurator: SnapshotConfigurator,
    fileID: StaticString = #fileID,
    file: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    let location = SnapshotLocation(fileID: fileID, file: file, line: line, column: column)
    guard PinnedSimulator.isCurrent else {
        Issue.record("\(PinnedSimulator.mismatchMessage)", sourceLocation: location.sourceLocation)
        return
    }
    guard FileManager.default.fileExists(atPath: snapshotsRoot.path(percentEncoded: false)) else {
        let message = "No Snapshots folder at \(snapshotsRoot.path()): was SnapshotHelper moved?"
        Issue.record("\(message)", sourceLocation: location.sourceLocation)
        return
    }
    let width = configurator.layout.width
    let sized = view
        .frame(width: width, alignment: .leading)
        .fixedSize(horizontal: false, vertical: width != nil)
        .background(Color(uiColor: .systemBackground))
    for style in configurator.interfaceStyles {
        for size in configurator.textSizes {
            configurator.verify(sized, named: name, style: style, size: size, at: location)
        }
    }
}

private enum PinnedSimulator {
    static let name = "iPhone 17"
    static let modelIdentifier = "iPhone18,3"
    static let systemVersion = "26.3.1"

    @MainActor static var isCurrent: Bool {
        environment("SIMULATOR_MODEL_IDENTIFIER") == modelIdentifier && UIDevice.current.systemVersion == systemVersion
    }

    @MainActor static var mismatchMessage: String {
        "Snapshots are recorded on \(name), iOS \(systemVersion) — "
            + "current: \(environment("SIMULATOR_DEVICE_NAME")), iOS \(UIDevice.current.systemVersion)"
    }

    private static func environment(_ key: String) -> String {
        ProcessInfo.processInfo.environment[key] ?? "unknown"
    }
}

private struct SnapshotLocation {
    let fileID: StaticString
    let file: StaticString
    let line: UInt
    let column: UInt

    var sourceLocation: SourceLocation {
        SourceLocation(fileID: "\(fileID)", filePath: "\(file)", line: Int(line), column: Int(column))
    }

    func directory(for size: SnapshotConfigurator.TextSize) -> String {
        let suite = URL(filePath: "\(file)").deletingPathExtension().lastPathComponent
        return snapshotsRoot.appending(path: suite).appending(path: size.rawValue).path(percentEncoded: false)
    }
}

/// `<repo>/Snapshots` — outside the synchronized test folder, so images are never copied into the test bundle.
/// This file lives in `<repo>/BlixRekrtuacjaTests/Snapshot/Support/`.
private let snapshotsRoot = URL(filePath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appending(path: "Snapshots")

private extension SnapshotConfigurator {
    @MainActor
    func verify(
        _ view: some View,
        named name: String,
        style: InterfaceStyle,
        size: TextSize,
        at location: SnapshotLocation
    ) {
        let failure = verifySnapshot(
            of: view.environment(\.dynamicTypeSize, size.dynamicTypeSize),
            as: .image(
                drawHierarchyInKeyWindow: drawsInWindow,
                layout: layout.snapshotLayout,
                traits: traits(style, size)
            ),
            named: style.rawValue,
            snapshotDirectory: location.directory(for: size),
            fileID: location.fileID,
            file: location.file,
            testName: name,
            line: location.line,
            column: location.column
        )
        guard let failure else { return }
        Issue.record("\(failure)", sourceLocation: location.sourceLocation)
    }
}
