import SwiftUI

/// Short content sits still, long content scrolls. In landscape (compact height) it always scrolls: there content
/// that loads more of itself (a footer `.task`) keeps crossing the fit boundary, and `ViewThatFits` swapping
/// between its children on every load crashed the app.
struct BlixList<Content: View>: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private let spacing: CGFloat
    private let content: Content

    init(spacing: CGFloat = Spacing.small, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        if verticalSizeClass == .compact {
            scrolling
        } else {
            ViewThatFits(in: .vertical) {
                stack
                scrolling
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }

    private var scrolling: some View {
        ScrollView { stack }
            .scrollBounceBehavior(.basedOnSize)
            .scrollIndicators(.hidden)
    }

    private var stack: some View {
        LazyVStack(alignment: .leading, spacing: spacing) { content }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.large)
    }
}

#Preview("Fits — no scroll") {
    BlixList {
        ForEach(1...3, id: \.self) { Text($0, format: .number) }
    }
}

#Preview("Landscape — always scrolls", traits: .landscapeLeft) {
    BlixList {
        ForEach(1...3, id: \.self) { Text($0, format: .number) }
    }
}

#Preview("Overflows — scrolls") {
    BlixList {
        ForEach(1...60, id: \.self) { Text($0, format: .number) }
    }
}
