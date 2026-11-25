import SwiftUI

/// A search field that is always visible: before iOS 26 the automatic drawer hides it until the list is pulled down,
/// with Liquid Glass it sits at the bottom.
struct BlixSearchable: ViewModifier {
    @Binding var text: String
    let prompt: Text

    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.searchable(text: $text, prompt: prompt)
        } else {
            content.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: prompt)
        }
    }
}

extension View {
    func blixSearchable(text: Binding<String>, prompt: Text) -> some View {
        modifier(BlixSearchable(text: text, prompt: prompt))
    }
}
