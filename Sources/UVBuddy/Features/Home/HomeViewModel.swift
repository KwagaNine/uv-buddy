import Foundation
import Observation
import UVBuddyCore

@MainActor
@Observable
final class HomeViewModel {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(message: String)
    }

    private let weatherService: WeatherService
    private let locationService: LocationService

    private(set) var weather: WeatherData = .placeholder
    private(set) var character: String = "UV Buddy"
    private(set) var state: ViewState = .idle

    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    var uvIndexText: String {
        String(format: "%.1f", weather.uvIndex)
    }

    var temperatureText: String {
        "\(Int(weather.temperatureCelsius.rounded())) C"
    }

    var weatherSummary: String {
        weather.conditionSummary
    }

    var spfRecommendation: String {
        weather.uvLevel.spfRecommendation
    }

    func load() async {
        state = .loading

        do {
            let location = try await locationService.currentLocation()
            weather = try await weatherService.fetchWeather(for: location)
            state = .loaded
        } catch {
            let fallbackMessage = "Unable to load weather data."
            state = .error(message: (error as? LocalizedError)?.errorDescription ?? fallbackMessage)
        }
    }

    func applyDebugMock(_ mock: WeatherData) {
        weather = mock
        state = .loaded
    }

#if DEBUG
    func applyDebugError(_ message: String = "Simulated debug error.") {
        state = .error(message: message)
    }

    func applyDebugLoading() {
        state = .loading
    }
#endif
}
