# Design System

The visual layer: tokens, colors, components and view modifiers. It knows nothing about Core, Data or features.

## Tokens
- Sizes and fonts come from `Spacing`, `Radius`, `Size` and `Typography` in `Tokens/`.
- Colors come from `Resources/Assets.xcassets/Colors` (light + dark) through the generated symbols:
  `.brandPrimary/Secondary`, `.backgroundPrimary/Secondary`, `.textPrimary/Secondary`, `.success`, `.warning`, `.error`, `.info`.
  The palette is based on blix.pl. A new color means a new colorset.
- Cards: `.cardBackground(.primary | .secondary)` with `Radius.large`. There are no other card colors.

## Components (`Components/Blix<Name>/`)
- Each component is `Blix<Name>.swift` (View) plus `Blix<Name>Configurator.swift` (struct).
  - The view only renders.
  - Mapping (colors, alignment) lives in the configurator.
  - Actions are `@MainActor () -> Void`.
- Text goes through `BlixLabel`: `.localized` for catalog keys, `.verbatim` for user data.
- Containers take `@ViewBuilder` content (`BlixList`).
- Dynamic Type xSmall–AX5: text wraps, rows use `minHeight: Size.minTapTarget`, nothing has a fixed text height.
- Before adding a component, check whether an existing one can take a new variant.

## Modifiers
Design System modifiers go in `Extensions/View+DesignSystem.swift` (`cardBackground`, `typography`).

## Tests
Every component has `#Preview`s covering all its variants and `Snapshot/DesignSystem/<Name>SnapshotTests.swift` (rules: `BlixRekrtuacjaTests/Snapshot/CLAUDE.md`).
A modifier with visual variants (`cardBackground`) has a snapshot test.
