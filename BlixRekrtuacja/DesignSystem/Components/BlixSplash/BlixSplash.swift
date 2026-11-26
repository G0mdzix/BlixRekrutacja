import SwiftUI

struct BlixSplash: View {
    let configurator: BlixSplashConfigurator

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isShown: Bool

    init(configurator: BlixSplashConfigurator, isShown: Bool = false) {
        self.configurator = configurator
        _isShown = State(initialValue: isShown)
    }

    var body: some View {
        ZStack {
            logo
                .scaleEffect(isShown ? Splash.logoScale : 1)
                .offset(y: isShown ? -Splash.logoLift : .zero)
            BlixAdaptiveRow(spreadsApart: false) {
                BlixLabel(configurator: configurator.brandLabel)
            } trailing: {
                BlixLabel(configurator: configurator.productLabel)
            }
            .alignmentGuide(VerticalAlignment.center) { $0[.top] - Splash.titleTop }
            .offset(y: isShown ? .zero : Splash.titleRise)
            .opacity(isShown ? 1 : .zero)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            BlixLabel(configurator: configurator.captionLabel)
                .opacity(isShown ? 1 : .zero)
                .animation(reduceMotion ? nil : .smooth.delay(Splash.captionDelay), value: isShown)
                .padding(.bottom, Splash.captionInset)
        }
        .background(.backgroundPrimary)
        .ignoresSafeArea()
        .onAppear { withAnimation(reduceMotion ? nil : .smooth.delay(Splash.delay)) { isShown = true } }
    }

    private var logo: some View {
        ZStack {
            Image(.logoBase)
            Image(.logoArrows)
                .rotationEffect(.degrees(isShown && !reduceMotion ? Splash.turn : .zero), anchor: Splash.arrowsCentre)
                .animation(
                    .linear(duration: Splash.turnDuration).repeatForever(autoreverses: false).delay(Splash.delay),
                    value: isShown
                )
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Constants

private enum Splash {
    static let delay = 0.3
    static let logoScale = 0.9
    static let logoLift: CGFloat = 56
    static let titleTop: CGFloat = 24
    static let titleRise: CGFloat = 14
    static let captionDelay = 0.8
    static let captionInset: CGFloat = 72
    static let turn = 360.0
    static let turnDuration = 1.6
    /// The centre of the arrows' circle in the 1024-point logo artwork.
    static let arrowsCentre = UnitPoint(x: 0.5, y: 590.0 / 1_024)
}

#Preview {
    BlixSplash(
        configurator: .init(
            brand: .localized(.ratesSplashBrand),
            product: .localized(.ratesSplashProduct),
            caption: .localized(.ratesLoading)
        )
    )
}
