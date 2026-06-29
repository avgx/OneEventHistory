import Foundation
import JSONValue

public struct Event: Codable, Equatable, Sendable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(EventBody.self, forKey: .body)
        eventName = try container.decodeIfPresent(String.self, forKey: .eventName) ?? ""
        eventType = try container.decode(String.self, forKey: .eventType)
        external = try container.decodeIfPresent(Bool.self, forKey: .external) ?? false
        localization = try container.decodeIfPresent(LocalizedText.self, forKey: .localization)
            ?? LocalizedText(text: "")
        requiredPermissions = try container.decodeIfPresent(RequiredPermissions.self, forKey: .requiredPermissions)
        subject = try container.decodeIfPresent(String.self, forKey: .subject) ?? ""
        subjects = try container.decodeIfPresent([String].self, forKey: .subjects) ?? []
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(eventName, forKey: .eventName)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(external, forKey: .external)
        try container.encode(localization, forKey: .localization)
        try container.encodeIfPresent(requiredPermissions, forKey: .requiredPermissions)
        try container.encode(subject, forKey: .subject)
        try container.encode(subjects, forKey: .subjects)
    }
}
