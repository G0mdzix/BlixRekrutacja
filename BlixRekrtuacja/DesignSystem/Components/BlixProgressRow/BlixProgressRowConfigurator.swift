import SwiftUI

struct BlixProgressRowConfigurator {
    let text: BlixLabelConfigurator.Content

    var label: BlixLabelConfigurator {
        BlixLabelConfigurator(text: text, style: .secondary, typography: .subheadline, alignment: .center)
    }
}
