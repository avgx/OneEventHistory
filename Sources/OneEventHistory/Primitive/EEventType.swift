import Foundation

/// Stored event type filter value (`EEventType`).
public enum EEventType: String, Codable, Equatable, Sendable {
    case detectorEvent = "ET_DetectorEvent"
    case bookmark = "ET_Bookmark"
    case alert = "ET_Alert"
    case textEvent = "ET_TextEvent"
}
