import Foundation
import Observation

@MainActor @Observable
final class SettingsViewModel {
    private let preferences: UserPreferences

    init(preferences: UserPreferences) {
        self.preferences = preferences
    }

    func select(_ appearance: Appearance) {
        preferences.set(appearance)
    }

    func select(_ language: Language) {
        preferences.set(language)
    }
}

// MARK: - UI configurators

extension SettingsViewModel {
    var appearanceHeaderConfigurator: BlixLabelConfigurator { header(.settingsAppearance) }

    var languageHeaderConfigurator: BlixLabelConfigurator { header(.settingsLanguage) }

    func appearanceRowConfigurator(_ appearance: Appearance) -> BlixSelectionRowConfigurator {
        BlixSelectionRowConfigurator(
            title: .localized(appearance.title),
            isSelected: appearance == preferences.appearance
        ) { [weak self] in
            guard let self else { return }
            select(appearance)
        }
    }

    func languageRowConfigurator(_ language: Language) -> BlixSelectionRowConfigurator {
        BlixSelectionRowConfigurator(
            title: .localized(language.title),
            isSelected: language == preferences.language
        ) { [weak self] in
            guard let self else { return }
            select(language)
        }
    }

    private func header(_ text: LocalizedStringResource) -> BlixLabelConfigurator {
        BlixLabelConfigurator(text: .localized(text), style: .secondary, typography: .subheadline)
    }
}
