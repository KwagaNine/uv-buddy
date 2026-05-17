import Foundation

protocol LocationService: Sendable {
    func currentLocation() async throws -> Coordinate
}

struct Coordinate: Sendable {
    let latitude: Double
    let longitude: Double
}

struct MockLocationService: LocationService, Sendable {
    func currentLocation() async throws -> Coordinate {
        Coordinate(latitude: 55.7558, longitude: 37.6176)
    }
}
