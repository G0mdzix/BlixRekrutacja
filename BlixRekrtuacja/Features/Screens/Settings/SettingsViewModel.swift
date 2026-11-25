import Foundation
import Observation

@MainActor @Observable
final class SettingsViewModel {
    private(set) var error: AppError?

    private let preferences: UserPreferences

    init(preferences: UserPreferences) {
        self.preferences = preferences
    }

    func select(_ appearance: Appearance) {
        do {
            try preferences.set(appearance)
        } catch {
            self.error = AppError(error)
        }
    }

    func select(_ language: Language) {
        do {
            try preferences.set(language)
        } catch {
            self.error = AppError(error)
        }
    }

    func dismissError() {
        error = nil
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
