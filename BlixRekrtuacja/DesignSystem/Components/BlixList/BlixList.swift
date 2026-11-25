import SwiftUI

/// Always a `ScrollView`; `.basedOnSize` keeps short content still. A `ViewThatFits` that swapped a still stack for a
/// scroll view crashed while the content changed (paging, search) and left the screen blank after a back swipe.
struct BlixList<Content: View>: View {
    private let spacing: CGFloat
    private let content: Content

    init(spacing: CGFloat = Spacing.small, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: spacing) { content }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}

#Preview("Fits — no scroll") {
    BlixList {
        ForEach(1...3, id: \.self) { Text($0, format: .number) }
    }
}

#Preview("Overflows — scrolls") {
    BlixList {
        ForEach(1...60, id: \.self) { Text($0, format: .number) }
    }
}
