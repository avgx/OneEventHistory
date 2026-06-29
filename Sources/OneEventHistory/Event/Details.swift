import Foundation

/// Optional per-detector details attached to an event body.
public struct Details: Codable, Equatable, Sendable {
    public let rectangle: Rectangle?
    public let faceRecognitionResult: FaceRecognitionResult?
    public let objectId: Int?

    private enum CodingKeys: String, CodingKey {
        case rectangle
        case faceRecognitionResult = "face_recognition_result"
        case objectId = "object_id"
    }
}
