import SwiftUI

struct BlixSurface<SurfaceShape: InsettableShape>: ViewModifier {
    let fill: Color
    var border: Color?
    let shape: SurfaceShape

    func body(content: Content) -> some View {
        content
            .background(fill, in: shape)
            .overlay {
                if let border { shape.strokeBorder(border, lineWidth: Size.borderWidth) }
            }
    }
}

extension View {
    func cardBackground(_ background: CardBackground) -> some View {
        modifier(BlixSurface(fill: background.color, border: .hairline, shape: .rect(cornerRadius: Radius.large)))
    }

    func circled(diameter: CGFloat, fill: Color, border: Color? = nil) -> some View {
        frame(width: diameter, height: diameter)
            .modifier(BlixSurface(fill: fill, border: border, shape: .circle))
    }
}
