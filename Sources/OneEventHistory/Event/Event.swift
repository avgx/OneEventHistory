import Foundation
import JSONValue

public struct Event: Decodable, Equatable, Sendable {
    public let body: EventBody
    public let eventName: String
    public let eventType: String
    public let external: Bool
    public let localization: LocalizedText
    public let requiredPermissions: RequiredPermissions?
    public let subject: String
    public let subjects: [String]

    private enum CodingKeys: String, CodingKey {
        case body
        case eventName = "event_name"
        case eventType = "event_type"
        case external
        case localization
        case requiredPermissions = "required_permissions"
        case subject
        case subjects
    }
}
