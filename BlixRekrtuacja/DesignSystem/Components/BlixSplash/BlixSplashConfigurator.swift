import SwiftUI

struct BlixSplashConfigurator {
    let brand: BlixLabelConfigurator.Content
    let product: BlixLabelConfigurator.Content
    let caption: BlixLabelConfigurator.Content

    var brandLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: brand, typography: .largeTitle)
    }

    var productLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: product, style: .accent, typography: .largeTitle)
    }

    var captionLabel: BlixLabelConfigurator {
        BlixLabelConfigurator(text: caption, style: .secondary, typography: .subheadline, alignment: .center)
    }
}
