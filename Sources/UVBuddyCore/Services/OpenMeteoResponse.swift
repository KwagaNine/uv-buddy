import Foundation

public struct OpenMeteoResponse: Decodable {
    public let current: CurrentWeather
    public let daily: DailyWeather

    public struct CurrentWeather: Decodable {
        public let temperature2m: Double?
        public let weatherCode: Int?
        public let uvIndex: Double?

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
            case uvIndex = "uv_index"
        }
    }

    public struct DailyWeather: Decodable {
        public let uvIndexMax: [Double]

        enum CodingKeys: String, CodingKey {
            case uvIndexMax = "uv_index_max"
        }
    }
}

public enum WeatherCodeMapper {
    public static func summary(for code: Int) -> String {
        switch code {
        case 0: return "Clear sky"
        case 1, 2, 3: return "Partly cloudy"
        case 45, 48: return "Fog"
        case 51, 53, 55, 56, 57: return "Drizzle"
        case 61, 63, 65, 66, 67: return "Rain"
        case 71, 73, 75, 77: return "Snow"
        case 80, 81, 82: return "Rain showers"
        case 85, 86: return "Snow showers"
        case 95, 96, 99: return "Thunderstorm"
        default: return "Unknown weather"
        }
    }
}

public enum OpenMeteoMapper {
    public static func map(_ response: OpenMeteoResponse) throws -> WeatherData {
        guard
            let temperature = response.current.temperature2m,
            let weatherCode = response.current.weatherCode
        else {
            throw WeatherServiceError.invalidResponse
        }

        let uvIndex = response.current.uvIndex ?? response.daily.uvIndexMax.first
        guard let uvIndex else {
            throw WeatherServiceError.invalidResponse
        }

        return WeatherData(
            uvIndex: uvIndex,
            temperatureCelsius: temperature,
            weatherCode: weatherCode,
            conditionSummary: WeatherCodeMapper.summary(for: weatherCode),
            updatedAt: .now
        )
    }
}
