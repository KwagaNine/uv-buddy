import XCTest
import Foundation
import UVBuddyCore

final class UVBuddyCoreTests: XCTestCase {
    func testUVLevelMapping() {
        XCTAssertEqual(UVLevel.from(uvIndex: 1.0), .low)
        XCTAssertEqual(UVLevel.from(uvIndex: 4.0), .moderate)
        XCTAssertEqual(UVLevel.from(uvIndex: 7.0), .high)
        XCTAssertEqual(UVLevel.from(uvIndex: 9.0), .veryHigh)
        XCTAssertEqual(UVLevel.from(uvIndex: 12.0), .extreme)
    }

    func testOpenMeteoMappingUsesDailyFallbackWhenCurrentUVMissing() throws {
        let json = """
        {
          "current": {
            "temperature_2m": 25.5,
            "weather_code": 2
          },
          "daily": {
            "uv_index_max": [8.4]
          }
        }
        """

        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        let weather = try OpenMeteoMapper.map(decoded)

        XCTAssertEqual(weather.temperatureCelsius, 25.5, accuracy: 0.001)
        XCTAssertEqual(weather.weatherCode, 2)
        XCTAssertEqual(weather.uvIndex, 8.4, accuracy: 0.001)
        XCTAssertEqual(weather.uvLevel, .veryHigh)
    }

    func testCacheServiceRoundTrip() async {
        let suiteName = "uvbuddy.tests.cache"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let cache = UserDefaultsCacheService(defaults: defaults, key: "weather")
        let input = WeatherData(
            uvIndex: 5.5,
            temperatureCelsius: 23,
            weatherCode: 1,
            conditionSummary: "Mainly clear",
            updatedAt: Date(timeIntervalSince1970: 1000)
        )

        await cache.save(weatherData: input)
        let output = await cache.loadWeatherData()

        XCTAssertEqual(output?.uvIndex, input.uvIndex, accuracy: 0.001)
        XCTAssertEqual(output?.temperatureCelsius, input.temperatureCelsius, accuracy: 0.001)
        XCTAssertEqual(output?.weatherCode, input.weatherCode)
        XCTAssertEqual(output?.conditionSummary, input.conditionSummary)
    }
}
