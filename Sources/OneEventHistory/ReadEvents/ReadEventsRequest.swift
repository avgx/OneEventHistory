import Foundation

/// Request body for `EventHistoryService.ReadEvents`.
public struct ReadEventsRequest: Encodable, Sendable {
    public let range: TimeRange
    public let filters: SearchFilterArray
    public let limit: Int?
    public let offset: Int?
    public let nodeDescriptions: [NodeDescription]?
    public let descending: Bool?
    public let `internal`: Bool?

    private enum CodingKeys: String, CodingKey {
        case range
        case filters
        case limit
        case offset
        case nodeDescriptions = "node_descriptions"
        case descending
        case `internal`
    }

    public init(
        range: TimeRange,
        filters: SearchFilterArray,
        limit: Int? = nil,
        offset: Int? = nil,
        nodeDescriptions: [NodeDescription]? = nil,
        descending: Bool? = nil,
        internal internalFlag: Bool? = nil
    ) {
        self.range = range
        self.filters = filters
        self.limit = limit
        self.offset = offset
        self.nodeDescriptions = nodeDescriptions
        self.descending = descending
        self.internal = internalFlag
    }
}
