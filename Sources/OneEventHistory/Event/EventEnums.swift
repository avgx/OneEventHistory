import Foundation
import SafeEnum

/// Event lifecycle state (`AlertStatus` on wire).
public enum EventState: String, Decodable, Equatable, Sendable {
    case active = "ACTIVE"
    case closed = "CLOSED"
}

/// Face evasion type on wire.
public enum EvasionType: String, Decodable, Equatable, Sendable {
    case none = "NONE"
    case mask = "MASK"
    case glasses = "GLASSES"
}

/// Gender value on wire.
public enum Gender: String, Decodable, Equatable, Sendable {
    case male = "MALE"
    case female = "FEMALE"
}
