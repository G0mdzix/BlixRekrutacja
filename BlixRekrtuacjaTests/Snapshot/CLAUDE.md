# Snapshot tests

General rules: `../CLAUDE.md`. Helper: `assertSnapshots(of:layout:)` in `SnapshotHelper.swift` renders light/dark × large/accessibility5.

## Layout
- `Snapshot/<Area>/<Type>SnapshotTests.swift`: one parameterized test per component or screen, every variant an argument.
- Suite tags: `.snapshot` plus the area, e.g. `@Suite(.tags(.snapshot, .feature))`.
- Components: `view.frame(width: 390)` with `layout: .sizeThatFits`. Screens: default `.device`.

## Scope
- Every visual variant and state: default, empty, error, loading, disabled.
- No combinations already covered by another case.
- Logic belongs in unit tests, not snapshots.

## Stable images
- State comes from stubs and is set before rendering. No network, async loading, animations or current date.
- Pinned simulator: iPhone 16, iOS 18.6.
- Texts come from the String Catalog in the development language.

## Recording
- Only for an intended UI change: prefix the test command with `TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all`.
- Review every new image before committing. Never re-record to make a failing test pass.
- Never lower `precision` / `perceptualPrecision` to make a test pass.
- `__Snapshots__/` is committed and excluded from target membership.
