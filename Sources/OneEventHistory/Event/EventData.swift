import Foundation
import JSONValue

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

    private enum CodingKeys: String, CodingKey {
        case detectorsGroup = "DetectorsGroup"
        case faceId = "FaceId"
        case objectId = "ObjectId"
        case detectorType = "detector_type"
        case originId = "origin_id"
        case phase
        case rectangles
        case hypotheses = "Hypotheses"
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
    }
}
