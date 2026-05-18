import Foundation
import UVBuddyCore

struct AppContainer {
    let weatherService: WeatherService
    let locationService: LocationService

    static let live = AppContainer(
        weatherService: OpenMeteoWeatherService(cacheService: UserDefaultsCacheService()),
        locationService: MockLocationService()
    )
}
