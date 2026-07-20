import Foundation
import OneWireFormat

/// Indexed field filter for advanced ReadEvents queries (`SearchByFieldFilter`).
public struct SearchByFieldFilter: Codable, Equatable, Sendable {
    public let fullPathToField: String
    public let value: String

    private enum CodingKeys: String, CodingKey {
        case fullPathToField = "full_path_to_field"
        case value
    }

    public init(fullPathToField: String, value: String) {
        self.fullPathToField = fullPathToField
        self.value = value
    }
}

/// ReadEvents filter (`SearchFilter`).
///
/// Field roles from proto:
/// - ``type`` — stored event category (`EEventType`)
/// - ``subjects`` — camera or object access points on one node
/// - ``values`` — exact-match event field values (meaning depends on ``type``)
/// - ``texts`` — partial-match event field values
public struct SearchFilter: Codable, Equatable, Sendable {
    /// Stored event category (`EEventType`).
    public let type: EEventType

    /// Camera or object access points; all entries must belong to the same node.
    public let subjects: [AccessPoint]

    /// Exact-match field values. For ``EEventType/detectorEvent``, use ``DetectorEventValue``.
    public let values: [String]

    /// Partial-match field values.
    public let texts: [String]?

    /// Optional indexed JSON-field filters.
    public let indexedValues: [SearchByFieldFilter]?

    private enum CodingKeys: String, CodingKey {
        case type
        case subjects
        case values
        case texts
        case indexedValues = "indexed_values"
    }

    public init(
        type: EEventType,
        subjects: [AccessPoint] = [],
        values: [String] = [],
        texts: [String]? = nil,
        indexedValues: [SearchByFieldFilter]? = nil
    ) {
        self.type = type
        self.subjects = subjects
        self.values = values
        self.texts = texts
        self.indexedValues = indexedValues
    }
}

public extension SearchFilter {
    /// Detector event filter aligned with axxonnext.webclient face search.
    static func detectorEvent(origin: AccessPoint, eventValues: [DetectorEventValue]) -> SearchFilter {
        SearchFilter(
            type: .detectorEvent,
            subjects: [origin],
            values: eventValues.map(\.rawValue)
        )
    }

    /// Detector event filter for multiple camera origins.
    static func detectorEvent(origins: [AccessPoint], eventValues: [DetectorEventValue]) -> SearchFilter {
        SearchFilter(
            type: .detectorEvent,
            subjects: origins,
            values: eventValues.map(\.rawValue)
        )
    }

    /// Face appeared events on a camera origin.
    static func faceAppeared(on origin: AccessPoint) -> SearchFilter {
        detectorEvent(origin: origin, eventValues: [.faceAppeared])
    }

    /// Object descriptor events on a camera origin.
    static func objectDescriptor(on origin: AccessPoint) -> SearchFilter {
        detectorEvent(origin: origin, eventValues: [.objectDescriptor])
    }

    /// Audit events (`ET_Audit`) filtered by operation type (`AuditEvent.EAuditEventType`).
    ///
    /// `values` use proto enum names (e.g. `AE_USER_LOGIN`).
    static func audit(
        operations: [AuditEventType],
        subjects: [AccessPoint] = []
    ) -> SearchFilter {
        SearchFilter(
            type: .audit,
            subjects: subjects,
            values: operations.map(\.rawValue)
        )
    }

    /// All audit events (`ET_Audit`), optionally scoped to subjects.
    static func audit(subjects: [AccessPoint] = []) -> SearchFilter {
        SearchFilter(type: .audit, subjects: subjects, values: [])
    }
}

/// Known `values` entries for ``EEventType/detectorEvent`` filters.
public enum DetectorEventValue: String, Codable, Equatable, Sendable {
    case faceAppeared = "faceAppeared"
    case objectDescriptor = "ObjectDescriptorEvent"
}

/// Wrapper for repeated ReadEvents filters (`SearchFilterArray`).
public struct SearchFilterArray: Codable, Equatable, Sendable {
    public let filters: [SearchFilter]

    public init(filters: [SearchFilter]) {
        self.filters = filters
    }
}
