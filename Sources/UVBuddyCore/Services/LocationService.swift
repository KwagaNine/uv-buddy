import Foundation

public protocol LocationService: Sendable {
    func currentLocation() async throws -> Coordinate
}

public struct Coordinate: Sendable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct MockLocationService: LocationService, Sendable {
    public init() {}

    public func currentLocation() async throws -> Coordinate {
        Coordinate(latitude: 55.7558, longitude: 37.6176)
    }
}
