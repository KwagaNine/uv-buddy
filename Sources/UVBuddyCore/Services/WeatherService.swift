import Foundation

public protocol WeatherService: Sendable {
    func fetchWeather(for location: Coordinate) async throws -> WeatherData
}

public enum WeatherServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(Int)
    case noDataAvailable

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid weather request URL."
        case .invalidResponse:
            return "Weather data format is invalid."
        case .requestFailed(let statusCode):
            return "Weather API request failed with status code \(statusCode)."
        case .noDataAvailable:
            return "Unable to load weather data and no cached data is available."
        }
    }
}

public struct OpenMeteoWeatherService: WeatherService, Sendable {
    private let session: URLSession
    private let cacheService: CacheService

    public init(session: URLSession = .shared, cacheService: CacheService) {
        self.session = session
        self.cacheService = cacheService
    }

    public func fetchWeather(for location: Coordinate) async throws -> WeatherData {
        do {
            let request = try makeRequest(for: location)
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherServiceError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw WeatherServiceError.requestFailed(httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(OpenMeteoResponse.self, from: data)
            let weatherData = try OpenMeteoMapper.map(apiResponse)
            await cacheService.save(weatherData: weatherData)
            return weatherData
        } catch {
            if let cachedData = await cacheService.loadWeatherData() {
                return cachedData
            }

            if let weatherError = error as? WeatherServiceError {
                throw weatherError
            }

            throw WeatherServiceError.noDataAvailable
        }
    }

    private func makeRequest(for location: Coordinate) throws -> URLRequest {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code,uv_index"),
            URLQueryItem(name: "daily", value: "uv_index_max"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        return URLRequest(url: url)
    }
}

public struct MockWeatherService: WeatherService, Sendable {
    public init() {}

    public func fetchWeather(for location: Coordinate) async throws -> WeatherData {
        _ = location

        try await Task.sleep(for: .milliseconds(250))

        return WeatherData(
            uvIndex: 5.8,
            temperatureCelsius: 24,
            weatherCode: 2,
            conditionSummary: "Partly cloudy",
            updatedAt: .now
        )
    }
}
