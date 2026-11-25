import SwiftUI

/// A navigation title that follows the app's language. A resource passed as is stays the same value when the language
/// changes, so the navigation bar keeps the text it was built with; the resolved string changes and updates it.
struct BlixNavigationTitle: ViewModifier {
    let title: LocalizedStringResource

    @Environment(\.locale) private var locale

    func body(content: Content) -> some View {
        var title = title
        title.locale = locale
        return content.navigationTitle(String(localized: title))
    }
}

extension View {
    func blixNavigationTitle(_ title: LocalizedStringResource) -> some View {
        modifier(BlixNavigationTitle(title: title))
    }
}
