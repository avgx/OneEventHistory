import Foundation
import JSONValue
import SafeEnum

/// Detector-specific event data payload.
public struct EventData: Codable, Equatable, Sendable {
    public let detectorsGroup: [String]?
    /// Face identifier — servers may send an integer legacy id or a UUID string.
    public let faceId: String?
    public let objectId: Int?
    public let detectorType: String?
    public let originId: String?
    public let phase: Int?
    public let rectangles: [[Double]]?
    public let hypotheses: [JSONValue]?
    public let vehicleColor: String?
    public let vehicleBrand: String?
    public let vehicleModel: String?
    /// Server ordinal. `36` is ``PlateType/privateVehicle``.
    public let plateType: SafeEnum<PlateType>?
    public let vehicleClass: SafeEnum<VehicleClass>?
    public let direction: SafeEnum<Direction>?
    public let headlights: SafeEnum<HeadlightsStatus>?

    private enum CodingKeys: String, CodingKey {
        case detectorsGroup = "DetectorsGroup"
        case faceId = "FaceId"
        case objectId = "ObjectId"
        case detectorType = "detector_type"
        case originId = "origin_id"
        case phase
        case rectangles
        case hypotheses = "Hypotheses"
        case vehicleColor = "VehicleColor"
        case vehicleBrand = "VehicleBrand"
        case vehicleModel = "VehicleModel"
        case plateType = "PlateType"
        case vehicleClass = "VehicleClass"
        case direction = "Direction"
        case headlights = "HeadlightsStatus"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        detectorsGroup = try container.decodeIfPresent([String].self, forKey: .detectorsGroup)
        faceId = Self.decodeFaceId(from: container)
        objectId = try container.decodeIfPresent(Int.self, forKey: .objectId)
        detectorType = try container.decodeIfPresent(String.self, forKey: .detectorType)
        originId = try container.decodeIfPresent(String.self, forKey: .originId)
        phase = try container.decodeIfPresent(Int.self, forKey: .phase)
        rectangles = try container.decodeIfPresent([[Double]].self, forKey: .rectangles)
        hypotheses = try container.decodeIfPresent([JSONValue].self, forKey: .hypotheses)
        vehicleColor = try container.decodeIfPresent(String.self, forKey: .vehicleColor)
        vehicleBrand = try container.decodeIfPresent(String.self, forKey: .vehicleBrand)
        vehicleModel = try container.decodeIfPresent(String.self, forKey: .vehicleModel)
        plateType = try container.decodeIfPresent(SafeEnum<PlateType>.self, forKey: .plateType)
        vehicleClass = try container.decodeIfPresent(SafeEnum<VehicleClass>.self, forKey: .vehicleClass)
        direction = try container.decodeIfPresent(SafeEnum<Direction>.self, forKey: .direction)
        headlights = try container.decodeIfPresent(SafeEnum<HeadlightsStatus>.self, forKey: .headlights)
    }

    private static func decodeFaceId(from container: KeyedDecodingContainer<CodingKeys>) -> String? {
        guard container.contains(.faceId) else { return nil }
        if let stringValue = try? container.decode(String.self, forKey: .faceId), !stringValue.isEmpty {
            return stringValue
        }
        if let intValue = try? container.decode(Int.self, forKey: .faceId) {
            return String(intValue)
        }
        return nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(detectorsGroup, forKey: .detectorsGroup)
        try container.encodeIfPresent(faceId, forKey: .faceId)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(detectorType, forKey: .detectorType)
        try container.encodeIfPresent(originId, forKey: .originId)
        try container.encodeIfPresent(phase, forKey: .phase)
        try container.encodeIfPresent(rectangles, forKey: .rectangles)
        try container.encodeIfPresent(hypotheses, forKey: .hypotheses)
        try container.encodeIfPresent(vehicleColor, forKey: .vehicleColor)
        try container.encodeIfPresent(vehicleBrand, forKey: .vehicleBrand)
        try container.encodeIfPresent(vehicleModel, forKey: .vehicleModel)
        try container.encodeIfPresent(plateType, forKey: .plateType)
        try container.encodeIfPresent(vehicleClass, forKey: .vehicleClass)
        try container.encodeIfPresent(direction, forKey: .direction)
        try container.encodeIfPresent(headlights, forKey: .headlights)
    }
}
