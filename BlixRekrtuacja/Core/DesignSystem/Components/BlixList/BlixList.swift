import SwiftUI

struct BlixList<Content: View>: View {
    private let spacing: CGFloat
    private let content: Content

    init(spacing: CGFloat = Spacing.small, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        ViewThatFits(in: .vertical) {
            stack
            ScrollView { stack }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var stack: some View {
        LazyVStack(alignment: .leading, spacing: spacing) { content }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.large)
    }
}

#Preview("Fits — no scroll") {
    BlixList {
        ForEach(Appearance.allCases, id: \.self) { Text($0.title) }
    }
}

#Preview("Overflows — scrolls") {
    BlixList {
        ForEach(1...60, id: \.self) { Text($0, format: .number) }
    }
}
