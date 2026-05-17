import Foundation

struct OpenMeteoResponse: Decodable {
    let current: CurrentWeather
    let daily: DailyWeather

    struct CurrentWeather: Decodable {
        let temperature2m: Double?
        let weatherCode: Int?
        let uvIndex: Double?

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
            case uvIndex = "uv_index"
        }
    }

    struct DailyWeather: Decodable {
        let uvIndexMax: [Double]

        enum CodingKeys: String, CodingKey {
            case uvIndexMax = "uv_index_max"
        }
    }
}

enum WeatherCodeMapper {
    static func summary(for code: Int) -> String {
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
