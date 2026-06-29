import Foundation
import JSONValue
import OneWireFormat
import SafeEnum

/// Event payload body returned by EventHistory list RPCs.
public struct EventBody: Codable, Equatable, Sendable {
    public let guid: String
    public let timestamp: String
    public let state: SafeEnum<EventState>?
    public let originDeprecated: String?
    public let originExt: JSONValue?
    public let detectorExt: JSONValue?
    public let camera: JSONValue?
    public let eventType: String?
    public let multiPhaseId: String?
    public let detectorsGroup: [String]?
    public let details: [Details]?
    public let data: EventData?

    private enum CodingKeys: String, CodingKey {
        case guid
        case timestamp
        case state
        case originDeprecated = "origin_deprecated"
        case originExt = "origin_ext"
        case detectorExt = "detector_ext"
        case camera
        case eventType = "event_type"
        case multiPhaseId = "multi_phase_id"
        case detectorsGroup = "detectors_group"
        case details
        case data
    }

    /// Parsed event timestamp when wire value is ASIP.
    public var timestampDate: Date? {
        Timestamp.utc.date(from: timestamp)
    }
}
