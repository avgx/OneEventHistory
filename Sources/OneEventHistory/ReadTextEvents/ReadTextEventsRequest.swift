import Foundation

/// Request body for `EventHistoryService.ReadTextEvents`.
public struct ReadTextEventsRequest: Encodable, Sendable {
    public let range: TimeRange
    public let filters: SearchTextFilterArray
    public let limit: Int?
    public let offset: Int?
    public let nodeDescriptions: [NodeDescription]?
    public let descending: Bool?

    private enum CodingKeys: String, CodingKey {
        case range
        case filters
        case limit
        case offset
        case nodeDescriptions = "node_descriptions"
        case descending
    }

    public init(
        range: TimeRange,
        filters: SearchTextFilterArray,
        limit: Int? = nil,
        offset: Int? = nil,
        nodeDescriptions: [NodeDescription]? = nil,
        descending: Bool? = nil
    ) {
        self.range = range
        self.filters = filters
        self.limit = limit
        self.offset = offset
        self.nodeDescriptions = nodeDescriptions
        self.descending = descending
    }
}
