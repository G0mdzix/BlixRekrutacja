@testable import BlixRekrtuacja

extension BlixSectionHeaderConfiguratorTests {
    struct Scenario {
        let badge: BlixLabelConfigurator.Content?
        let caption: BlixLabelConfigurator.Content?
        let badgeStyle: BlixLabelConfigurator.Style?
        let captionStyle: BlixLabelConfigurator.Style?
        let hasDetails: Bool
    }

    static let headers: [Scenario] = [
        Scenario(
            badge: .verbatim("Today"),
            caption: .verbatim("10:00"),
            badgeStyle: .onBrand,
            captionStyle: .secondary,
            hasDetails: true
        ),
        Scenario(
            badge: nil,
            caption: .verbatim("Closing rate"),
            badgeStyle: nil,
            captionStyle: .secondary,
            hasDetails: true
        ),
        Scenario(badge: nil, caption: nil, badgeStyle: nil, captionStyle: nil, hasDetails: false)
    ]
}
