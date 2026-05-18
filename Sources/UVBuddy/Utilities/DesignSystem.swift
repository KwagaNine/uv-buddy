import SwiftUI

enum DesignSystem {
    enum Colors {
        static let background = Color(red: 0.96, green: 0.97, blue: 0.98)
        static let primaryText = Color(red: 0.12, green: 0.14, blue: 0.16)
        static let secondaryText = Color(red: 0.36, green: 0.40, blue: 0.45)
        static let accent = Color(red: 0.03, green: 0.45, blue: 0.84)
    }

    enum Spacing {
        static let xSmall: CGFloat = 6
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }

    enum Radius {
        static let card: CGFloat = 30
        static let pill: CGFloat = 16
    }

    enum Shadow {
        static let cardColor = Color.black.opacity(0.16)
        static let cardRadius: CGFloat = 24
        static let cardY: CGFloat = 12
    }

    enum Typography {
        static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
        static let subtitle = Font.system(size: 16, weight: .medium, design: .rounded)
        static let hero = Font.system(size: 44, weight: .semibold, design: .rounded)
        static let value = Font.system(size: 34, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 18, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 16, weight: .medium, design: .rounded)
        static let micro = Font.system(size: 13, weight: .medium, design: .rounded)
    }

    static func glassBackground(cornerRadius: CGFloat = Radius.card) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.28), lineWidth: 1)
            )
    }
}
