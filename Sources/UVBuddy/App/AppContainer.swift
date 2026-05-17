import Foundation

struct AppContainer {
    let weatherService: WeatherService
    let locationService: LocationService

    static let live = AppContainer(
        weatherService: OpenMeteoWeatherService(cacheService: UserDefaultsCacheService()),
        locationService: MockLocationService()
    )
}
