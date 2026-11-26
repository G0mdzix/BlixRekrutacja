# Design System

The visual layer: tokens, colors, components and view modifiers. It knows nothing about Core, Data or features.

## Tokens
- Sizes and fonts come from `Spacing`, `Radius`, `Size`, `Opacity` and `Typography` in `Tokens/`.
- Colors come from `Resources/Assets.xcassets/Colors` (light + dark) through the generated symbols:
  `.brandPrimary`, `.backgroundPrimary/Secondary`, `.textPrimary/Secondary`, `.textPositive/Negative`, `.textOnBrand`,
  `.hairline`, `.fillMuted`, `.errorSubtle`, `.error`.
  On light grounds `brandPrimary` is below 3:1: fills only; text and icons use `textPositive`.
  The palette is based on blix.pl. A new color means a new colorset.
- Cards: `.cardBackground(.primary | .secondary)` with `Radius.large` and a `hairline` border. There are no other card colors.

## Components (`Components/Blix<Name>/`)
- Each component is `Blix<Name>.swift` (View) plus `Blix<Name>Configurator.swift` (struct).
  - The view only renders.
  - Mapping (colors, alignment) lives in the configurator.
  - Actions are `@MainActor () -> Void`; optional only when the component can be non-interactive (`BlixRateRow`).
  - Configurators take `Content` for text; components that format their own numbers (`BlixRateRow`,
    `BlixChangeIndicator`, `BlixLineChart`) take raw values. Computed label configurators: `label` for one text,
    `<field>Label` for several.
  - Composite components take child configurators as stored properties (`BlixMessageCardConfigurator.button`).
- Text goes through `BlixLabel`: `.localized` for catalog keys, `.verbatim` for user data, `.number`/`.percent` for decimals
  (`monospacedDigits: true` in columns), `.date(_, FormatStyle)` for dates. Styles: `.accent` for interactive text, `.positive`/`.negative` only for gains and losses.
- Containers take `@ViewBuilder` content (`BlixList`, `BlixAdaptiveRow`).
  `BlixList`: always a `ScrollView` with a `LazyVStack`; `.basedOnSize` keeps short content still. No `ViewThatFits`:
  swapping branches crashed while content changed and left the screen blank after a back swipe.
  Scroll indicators are hidden there for every screen; screens never set `scrollIndicators` themselves.
- Charts go through `BlixLineChart` (Swift Charts, values as `Decimal`, the area starts at the lowest value).
- `BlixSplash` is the first load, full screen; the screen hides the navigation bar. Its first frame equals the launch
  screen (`UILaunchScreen` in Info.plist: `LaunchLogo` on `backgroundPrimary`); the logo lifts, the title shows and
  `LogoArrows` turn until the data arrives (Reduce Motion: no movement). Logo artwork is SVG in
  `Resources/Assets.xcassets/Logo/`; `LaunchLogo` must stay `LogoBase` + `LogoArrows`.
- Layouts that change at accessibility text sizes go through `BlixAdaptiveRow`; components never read `dynamicTypeSize` themselves.
- Dynamic Type xSmall–AX5: text wraps, rows use `minHeight: Size.minTapTarget`, nothing has a fixed text height.
- Before adding a component, check whether an existing one can take a new variant.

## Modifiers and styles
- `Modifiers/BlixSurface.swift`: the `BlixSurface` view modifier (fill + optional border) and its shortcuts `cardBackground`, `circled`;
  `Modifiers/CardBackground.swift` holds the card fills.
- `Modifiers/BlixSearchable.swift`: `blixSearchable(text:prompt:)`, a search field visible without pulling the list;
  a tap on the content hides the keyboard.
- `Modifiers/BlixNavigationTitle.swift`: `blixNavigationTitle(_:)`, a title that updates when the app's language changes.
- `Extensions/View+DesignSystem.swift`: `typography`.
- Buttons get their look from a `ButtonStyle` (`BlixButtonStyle`): pressed and disabled dim the content, never the fill.

## Tests
Every component has `#Preview`s covering all its variants and `Snapshot/DesignSystem/<Name>SnapshotTests.swift` (rules: `BlixRekrtuacjaTests/Snapshot/CLAUDE.md`).
A modifier with visual variants (`cardBackground`) has a snapshot test.
