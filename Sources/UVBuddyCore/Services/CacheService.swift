import Foundation

public protocol CacheService: Sendable {
    func save(weatherData: WeatherData) async
    func loadWeatherData() async -> WeatherData?
}

public actor UserDefaultsCacheService: CacheService {
    private let defaults: UserDefaults
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        defaults: UserDefaults = .standard,
        key: String = "uvbuddy.cached.weather",
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.defaults = defaults
        self.key = key
        self.encoder = encoder
        self.decoder = decoder
    }

    public func save(weatherData: WeatherData) async {
        guard let data = try? encoder.encode(weatherData) else {
            return
        }

        defaults.set(data, forKey: key)
    }

    public func loadWeatherData() async -> WeatherData? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        return try? decoder.decode(WeatherData.self, from: data)
    }
}
