import SwiftUI
import UIKit

/// A search field that is always visible: before iOS 26 the automatic drawer hides it until the list is pulled down,
/// with Liquid Glass it sits at the bottom. A tap on the content hides the keyboard; buttons in it still work.
struct BlixSearchable: ViewModifier {
    @Binding var text: String
    let prompt: Text

    func body(content: Content) -> some View {
        let tappable = content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        if #available(iOS 26, *) {
            tappable.searchable(text: $text, prompt: prompt)
        } else {
            tappable.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: prompt)
        }
    }
}

extension View {
    func blixSearchable(text: Binding<String>, prompt: Text) -> some View {
        modifier(BlixSearchable(text: text, prompt: prompt))
    }
}
