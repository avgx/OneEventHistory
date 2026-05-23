import Foundation

/// Request body for `EventHistoryService.ReadLprEvents`.
public struct ReadLprEventsRequest: Encodable, Sendable {
    public let range: TimeRange
    public let filters: LprSearchFilterArray
    public let searchPredicate: String?
    public let limit: Int?
    public let offset: Int?
    public let nodeDescriptions: [NodeDescription]?
    public let descending: Bool?

    private enum CodingKeys: String, CodingKey {
        case range
        case filters
        case searchPredicate = "search_predicate"
        case limit
        case offset
        case nodeDescriptions = "node_descriptions"
        case descending
    }

    public init(
        range: TimeRange,
        filters: LprSearchFilterArray,
        searchPredicate: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        nodeDescriptions: [NodeDescription]? = nil,
        descending: Bool? = nil
    ) {
        self.range = range
        self.filters = filters
        self.searchPredicate = searchPredicate
        self.limit = limit
        self.offset = offset
        self.nodeDescriptions = nodeDescriptions
        self.descending = descending
    }
}
