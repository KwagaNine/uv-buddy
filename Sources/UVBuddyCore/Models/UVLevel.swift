import Foundation

public enum UVLevel: String, Sendable {
    case low
    case moderate
    case high
    case veryHigh
    case extreme

    public static func from(uvIndex: Double) -> UVLevel {
        switch uvIndex {
        case ..<3: return .low
        case ..<6: return .moderate
        case ..<8: return .high
        case ..<11: return .veryHigh
        default: return .extreme
        }
    }

    public var spfRecommendation: String {
        switch self {
        case .low: return "SPF 15+"
        case .moderate: return "SPF 30"
        case .high: return "SPF 30+"
        case .veryHigh: return "SPF 50"
        case .extreme: return "SPF 50+"
        }
    }
}
