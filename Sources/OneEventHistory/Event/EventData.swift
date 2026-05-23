import Foundation
import JSONValue

/// Detector-specific event data payload.
public struct EventData: Decodable, Equatable, Sendable {
    public let detectorsGroup: [String]
    public let faceId: Int
    public let objectId: Int
    public let detectorType: String
    public let originId: String
    public let phase: Int
    public let rectangles: [[Double]]
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
}
