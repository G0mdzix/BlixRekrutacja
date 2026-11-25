import Charts
import SwiftUI

struct BlixLineChart: View {
    let configurator: BlixLineChartConfigurator

    var body: some View {
        Chart(configurator.points, id: \.date) { point in
            AreaMark(
                x: .value(Axis.date, point.date),
                yStart: .value(Axis.value, configurator.lowestValue),
                yEnd: .value(Axis.value, point.value)
            )
            .foregroundStyle(Color.brandPrimary.opacity(Opacity.chartFill))
            LineMark(x: .value(Axis.date, point.date), y: .value(Axis.value, point.value))
                .foregroundStyle(Color.textPositive)
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXScale(range: .plotDimension(padding: Spacing.extraLarge))
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: configurator.points.map(\.date)) {
                AxisValueLabel(format: configurator.dateFormat, anchor: .top, collisionResolution: .greedy)
            }
        }
        .frame(height: Size.chartHeight)
        .padding(Spacing.large)
        .cardBackground(.primary)
    }
}

// MARK: - Constants

private enum Axis {
    static let date = "date"
    static let value = "value"
}

#Preview {
    let values: [Decimal] = [4.449, 4.468, 4.455, 4.437, 4.473]
    BlixLineChart(
        configurator: .init(
            points: values.indices.map { .init(date: .now.addingTimeInterval(Double($0) * 86_400), value: values[$0]) },
            dateFormat: .dateTime.day().month(.abbreviated)
        )
    )
    .padding(Spacing.large)
}
