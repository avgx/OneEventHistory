import Foundation
import JSONValue

/// Optional per-detector details attached to an event body.
public struct Details: Codable, Equatable, Sendable {
    public let rectangle: Rectangle?
    public let faceRecognitionResult: FaceRecognitionResult?
    public let objectId: Int?
    /// Raw `auto_recognition_result` block. Kept as JSON because servers vary the schema.
    public let autoRecognitionResult: JSONValue?
    /// Raw `auto_recognition_result_ex` block.
    public let autoRecognitionResultEx: JSONValue?

    private enum CodingKeys: String, CodingKey {
        case rectangle
        case faceRecognitionResult = "face_recognition_result"
        case objectId = "object_id"
        case autoRecognitionResult = "auto_recognition_result"
        case autoRecognitionResultEx = "auto_recognition_result_ex"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rectangle = try container.decodeIfPresent(Rectangle.self, forKey: .rectangle)
        faceRecognitionResult = try container.decodeIfPresent(FaceRecognitionResult.self, forKey: .faceRecognitionResult)
        objectId = try container.decodeIfPresent(Int.self, forKey: .objectId)
        autoRecognitionResult = try container.decodeIfPresent(JSONValue.self, forKey: .autoRecognitionResult)
        autoRecognitionResultEx = try container.decodeIfPresent(JSONValue.self, forKey: .autoRecognitionResultEx)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(rectangle, forKey: .rectangle)
        try container.encodeIfPresent(faceRecognitionResult, forKey: .faceRecognitionResult)
        try container.encodeIfPresent(objectId, forKey: .objectId)
        try container.encodeIfPresent(autoRecognitionResult, forKey: .autoRecognitionResult)
        try container.encodeIfPresent(autoRecognitionResultEx, forKey: .autoRecognitionResultEx)
    }
}
