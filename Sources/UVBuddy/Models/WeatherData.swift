import Foundation

struct WeatherData: Sendable, Codable {
    let uvIndex: Double
    let temperatureCelsius: Double
    let weatherCode: Int
    let conditionSummary: String
    let updatedAt: Date

    var uvLevel: UVLevel {
        UVLevel.from(uvIndex: uvIndex)
    }

    static let placeholder = WeatherData(
        uvIndex: 3.0,
        temperatureCelsius: 21,
        weatherCode: 0,
        conditionSummary: "Clear sky",
        updatedAt: .now
    )

    static let mockLow = WeatherData(
        uvIndex: 1.4,
        temperatureCelsius: 18,
        weatherCode: 0,
        conditionSummary: "Clear sky",
        updatedAt: .now
    )

    static let mockModerate = WeatherData(
        uvIndex: 4.8,
        temperatureCelsius: 22,
        weatherCode: 2,
        conditionSummary: "Partly cloudy",
        updatedAt: .now
    )

    static let mockHigh = WeatherData(
        uvIndex: 7.1,
        temperatureCelsius: 27,
        weatherCode: 61,
        conditionSummary: "Rain",
        updatedAt: .now
    )

    static let mockVeryHigh = WeatherData(
        uvIndex: 9.3,
        temperatureCelsius: 31,
        weatherCode: 1,
        conditionSummary: "Mainly clear",
        updatedAt: .now
    )

    static let mockExtreme = WeatherData(
        uvIndex: 12.2,
        temperatureCelsius: 35,
        weatherCode: 3,
        conditionSummary: "Overcast",
        updatedAt: .now
    )
}
