import SwiftUI
import UVBuddyCore

struct UVStatusCard: View {
    let uvIndexText: String
    let uvLevel: UVLevel
    let spfRecommendation: String
    let temperatureText: String
    let weatherSummary: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HStack(alignment: .firstTextBaseline) {
                Text(uvIndexText)
                    .font(DesignSystem.Typography.hero)
                    .foregroundStyle(DesignSystem.Colors.primaryText)
                    .accessibilityLabel("UV index \(uvIndexText)")
                Spacer()
                Text(riskTitle)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.secondaryText)
            }

            HStack(spacing: DesignSystem.Spacing.medium) {
                labelValue("SPF", spfRecommendation, accessibility: "SPF recommendation \(spfRecommendation)")
                labelValue("Temp", temperatureText, accessibility: "Temperature \(temperatureText)")
            }

            Text(weatherSummary)
                .font(DesignSystem.Typography.body)
                .foregroundStyle(DesignSystem.Colors.primaryText)
                .accessibilityLabel("Weather \(weatherSummary)")

            Text("Keep skin protected and hydrated for a comfortable day.")
                .font(DesignSystem.Typography.micro)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
        }
        .padding(DesignSystem.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.glassBackground())
        .shadow(color: DesignSystem.Shadow.cardColor, radius: DesignSystem.Shadow.cardRadius, x: 0, y: DesignSystem.Shadow.cardY)
    }

    private func labelValue(_ label: String, _ value: String, accessibility: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(label)
                .font(DesignSystem.Typography.micro)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
            Text(value)
                .font(DesignSystem.Typography.subtitle)
                .foregroundStyle(DesignSystem.Colors.primaryText)
                .accessibilityLabel(accessibility)
        }
    }

    private var riskTitle: String {
        switch uvLevel {
        case .low: return "Low risk"
        case .moderate: return "Moderate risk"
        case .high: return "High risk"
        case .veryHigh: return "Very high risk"
        case .extreme: return "Extreme risk"
        }
    }
}

#Preview {
    UVStatusCard(
        uvIndexText: "7.2",
        uvLevel: .high,
        spfRecommendation: "SPF 30+",
        temperatureText: "27 C",
        weatherSummary: "Partly cloudy"
    )
    .padding()
    .background(Color.gray.opacity(0.2))
}
