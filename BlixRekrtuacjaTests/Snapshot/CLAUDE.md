# Snapshot tests

General rules: `../CLAUDE.md`. Helper: `assertSnapshots(of:named:configurator:)` in `Support/SnapshotHelper.swift`;
`SnapshotConfigurator` sets interface styles (light + dark), text sizes and layout; every test passes one explicitly.

## Layout
- `Snapshot/<Area>/<Type>SnapshotTests.swift`: one parameterized test per component or screen, every variant an argument.
- The test function is always `recordSnapshot(_ scenario: Scenario)`. The file name must match the suite name — it names the `Snapshots/` folder.
- Suite tags: `.snapshot` plus the area, e.g. `@Suite(.tags(.snapshot, .feature))`.
- Screens: `configurator: .screen` (iPhone 13 frame 390×844 in a real window; light + dark, large only; settled states,
  no spinners). Components: `.component` (width 390, height fits content; xSmall + large + ax5).
  Containers whose behaviour depends on height (scrolling lists): `.component.layout(.screen)` or `.component.layout(.fixed(width:height:))`.
  Custom: `SnapshotConfigurator(textSizes: [.extraSmall, .accessibility5], layout: .fixed(width: 390, height: 300))`.
- Files: `Snapshots/<Suite>/<textSize>/<scenario>.<style>.png` at the repo root, e.g. `Snapshots/BlixListSnapshotTests/ax5/fits.dark.png`.
  Outside the test folder on purpose — never move them inside it (Xcode would copy them into the test bundle). `named:` = scenario name.

## Scope
- Every visual variant and state: default, empty, error, loading, disabled.
- No combinations already covered by another case.
- Logic belongs in unit tests, not snapshots.

## Stable images
- State comes from stubs and is set before rendering. No network, async loading, animations or current date.
- Pinned simulator: iPhone 17, iOS 26.3.1 — `SnapshotHelper` fails any other device or OS.
- Texts come from the String Catalog in the development language.

## Recording
- Only for an intended UI change: run scheme `SnapshotRecord` (re-records only missing or changed images and fails those tests),
  then `SnapshotTests` must pass. Never add a record switch to `SnapshotTests.xctestplan`.
- Review every new image before committing. Never re-record to make a failing test pass.
- Never lower `precision` / `perceptualPrecision` to make a test pass.
- `Snapshots/` is committed.
