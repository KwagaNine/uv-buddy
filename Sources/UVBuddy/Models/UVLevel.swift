import Foundation
import SwiftUI

enum UVLevel: String, Sendable {
    case low
    case moderate
    case high
    case veryHigh
    case extreme

    static func from(uvIndex: Double) -> UVLevel {
        switch uvIndex {
        case ..<3: return .low
        case ..<6: return .moderate
        case ..<8: return .high
        case ..<11: return .veryHigh
        default: return .extreme
        }
    }

    var spfRecommendation: String {
        switch self {
        case .low: return "SPF 15+"
        case .moderate: return "SPF 30"
        case .high: return "SPF 30+"
        case .veryHigh: return "SPF 50"
        case .extreme: return "SPF 50+"
        }
    }

    var glowIntensity: Double {
        switch self {
        case .low: return 0.25
        case .moderate: return 0.45
        case .high: return 0.65
        case .veryHigh: return 0.85
        case .extreme: return 1.0
        }
    }

    var glowColor: Color {
        switch self {
        case .low: return Color(red: 1.00, green: 0.93, blue: 0.62)
        case .moderate: return Color(red: 1.00, green: 0.85, blue: 0.36)
        case .high: return Color(red: 1.00, green: 0.66, blue: 0.26)
        case .veryHigh: return Color(red: 1.00, green: 0.52, blue: 0.18)
        case .extreme: return Color(red: 0.96, green: 0.35, blue: 0.18)
        }
    }

    var orbScale: Double {
        switch self {
        case .low: return 0.92
        case .moderate: return 1.0
        case .high: return 1.08
        case .veryHigh: return 1.15
        case .extreme: return 1.24
        }
    }

    var backgroundGradient: LinearGradient {
        let top = glowColor.opacity(0.16 + (0.2 * glowIntensity))
        let bottom = Color(red: 0.94, green: 0.95, blue: 0.97)

        return LinearGradient(
            colors: [top, bottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
