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

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(vehicleClass, forKey: .vehicleClass)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(brand, forKey: .brand)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(headlightsStatus, forKey: .headlightsStatus)
        try container.encodeIfPresent(speedFromKmph, forKey: .speedFromKmph)
        try container.encodeIfPresent(speedToKmph, forKey: .speedToKmph)
        try container.encodeIfPresent(purpose, forKey: .purpose)
        if let country {
            try container.encode(["value": country], forKey: .country)
        }
        if let plateState {
            try container.encode(["value": plateState], forKey: .plateState)
        }
    }
}
