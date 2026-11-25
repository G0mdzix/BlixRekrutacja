# Design System

The visual layer: tokens, colors, components and view modifiers. It knows nothing about Core, Data or features.

## Tokens
- Sizes and fonts come from `Spacing`, `Radius`, `Size`, `Opacity` and `Typography` in `Tokens/`.
- Colors come from `Resources/Assets.xcassets/Colors` (light + dark) through the generated symbols:
  `.brandPrimary/Secondary`, `.backgroundPrimary/Secondary`, `.textPrimary/Secondary`, `.textPositive/Negative`, `.textOnBrand`,
  `.hairline`, `.fillMuted`, `.selectedBackground`, `.errorSubtle`, `.success`, `.warning`, `.error`, `.info`.
  On light grounds `brandPrimary`, `success` and `warning` are below 3:1: fills only; text and icons use `textPositive`.
  The palette is based on blix.pl. A new color means a new colorset.
- Cards: `.cardBackground(.primary | .secondary)` with `Radius.large` and a `hairline` border. There are no other card colors.

## Components (`Components/Blix<Name>/`)
- Each component is `Blix<Name>.swift` (View) plus `Blix<Name>Configurator.swift` (struct).
  - The view only renders.
  - Mapping (colors, alignment) lives in the configurator.
  - Actions are `@MainActor () -> Void`; optional only when the component can be non-interactive (`BlixRateRow`).
  - Configurators take `Content` and expose computed label configurators: `label` for one text, `<field>Label` for several.
- Text goes through `BlixLabel`: `.localized` for catalog keys, `.verbatim` for user data, `.number`/`.percent` for decimals
  (`monospacedDigits: true` in columns), `.date(_, FormatStyle)` for dates. Styles: `.accent` for interactive text, `.positive`/`.negative` only for gains and losses.
- Containers take `@ViewBuilder` content (`BlixList`, `BlixAdaptiveRow`).
  `BlixList`: `ViewThatFits` (still stack or `ScrollView`) in portrait, always `ScrollView` at compact height:
  switching branches while a list loads more of itself crashed in landscape.
  Scroll indicators are hidden there for every screen; screens never set `scrollIndicators` themselves.
- Layouts that change at accessibility text sizes go through `BlixAdaptiveRow`; components never read `dynamicTypeSize` themselves.
- Dynamic Type xSmall–AX5: text wraps, rows use `minHeight: Size.minTapTarget`, nothing has a fixed text height.
- Before adding a component, check whether an existing one can take a new variant.

## Modifiers and styles
- `Modifiers/BlixSurface.swift`: the `BlixSurface` view modifier (fill + optional border) and its shortcuts `cardBackground`, `circled`.
- `Modifiers/BlixSearchable.swift`: `blixSearchable(text:prompt:)`, a search field visible without pulling the list.
- `Extensions/View+DesignSystem.swift`: `typography`.
- Buttons get their look from a `ButtonStyle` (`BlixButtonStyle`): pressed and disabled dim the content, never the fill.

## Tests
Every component has `#Preview`s covering all its variants and `Snapshot/DesignSystem/<Name>SnapshotTests.swift` (rules: `BlixRekrtuacjaTests/Snapshot/CLAUDE.md`).
A modifier with visual variants (`cardBackground`) has a snapshot test.
