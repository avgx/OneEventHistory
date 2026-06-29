import Foundation
import SafeEnum

/// Event lifecycle state (`AlertStatus` on wire).
public enum EventState: String, Codable, Equatable, Sendable {
    case active = "ACTIVE"
    case closed = "CLOSED"
}

/// Face evasion type on wire.
public enum EvasionType: String, Codable, Equatable, Sendable {
    case none = "NONE"
    case mask = "MASK"
    case glasses = "GLASSES"
}

/// Gender value on wire.
public enum Gender: String, Codable, Equatable, Sendable {
    case male = "MALE"
    case female = "FEMALE"
}
