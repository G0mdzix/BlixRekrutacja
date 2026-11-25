import Foundation

struct BlixLineChartConfigurator {
    struct Point {
        let date: Date
        let value: Decimal
    }

    /// Oldest first.
    let points: [Point]
    let dateFormat: Date.FormatStyle

    /// The area starts here, so a rate near 4 is not drawn as a wall rising from zero.
    var lowestValue: Decimal { points.map(\.value).min() ?? .zero }
}
