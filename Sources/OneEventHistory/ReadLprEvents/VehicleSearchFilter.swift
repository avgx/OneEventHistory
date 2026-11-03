import Foundation

/// Vehicle attribute filter for LPR search (`VehicleSearchFilter`).
public struct VehicleSearchFilter: Codable, Equatable, Sendable {
    public let direction: String?
    public let vehicleClass: String?
    public let color: String?
    public let brand: String?
    public let model: String?
    public let headlightsStatus: String?
    public let speedFromKmph: String?
    public let speedToKmph: String?
    public let purpose: String?
    public let country: String?
    public let plateState: String?

    private enum CodingKeys: String, CodingKey {
        case direction
        case vehicleClass = "class"
        case color
        case brand
        case model
        case headlightsStatus = "headlights_status"
        case speedFromKmph = "speed_from_kmph"
        case speedToKmph = "speed_to_kmph"
        case purpose
        case country
        case plateState = "plate_state"
    }

    public init(
        direction: String? = nil,
        vehicleClass: String? = nil,
        color: String? = nil,
        brand: String? = nil,
        model: String? = nil,
        headlightsStatus: String? = nil,
        speedFromKmph: String? = nil,
        speedToKmph: String? = nil,
        purpose: String? = nil,
        country: String? = nil,
        plateState: String? = nil
    ) {
        self.direction = direction
        self.vehicleClass = vehicleClass
        self.color = color
        self.brand = brand
        self.model = model
        self.headlightsStatus = headlightsStatus
        self.speedFromKmph = speedFromKmph
        self.speedToKmph = speedToKmph
        self.purpose = purpose
        self.country = country
        self.plateState = plateState
    }

    /// Nested protobuf messages and enums are JSON objects `{"value": ...}` in both clients.
    /// Desktop builds them as protobuf wrappers. The web `vehicleSaga` sends the same object
    /// for class, color, brand, model, headlights, direction, purpose, country, and plate state.
    /// A bare string is what this type used to emit for every field except country and plate state,
    /// and the gateway does not treat that as the enum. Speed stays a number: proto declares
    /// `speed_from_kmph` and `speed_to_kmph` as `double`, and the web client sends a number too.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encodeWrapped(direction, forKey: .direction, in: &container)
        try encodeWrapped(vehicleClass, forKey: .vehicleClass, in: &container)
        try encodeWrapped(color, forKey: .color, in: &container)
        try encodeWrapped(brand, forKey: .brand, in: &container)
        try encodeWrapped(model, forKey: .model, in: &container)
        try encodeWrapped(headlightsStatus, forKey: .headlightsStatus, in: &container)
        try encodeSpeed(speedFromKmph, forKey: .speedFromKmph, in: &container)
        try encodeSpeed(speedToKmph, forKey: .speedToKmph, in: &container)
        try encodeWrapped(purpose, forKey: .purpose, in: &container)
        try encodeWrapped(country, forKey: .country, in: &container)
        try encodeWrapped(plateState, forKey: .plateState, in: &container)
    }

    private func encodeWrapped(
        _ value: String?,
        forKey key: CodingKeys,
        in container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        guard let value else { return }
        try container.encode(["value": value], forKey: key)
    }

    private func encodeSpeed(
        _ value: String?,
        forKey key: CodingKeys,
        in container: inout KeyedEncodingContainer<CodingKeys>
    ) throws {
        guard let value, let number = Double(value) else { return }
        try container.encode(number, forKey: key)
    }
}
