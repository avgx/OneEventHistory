import Foundation

/// Request body for `EventHistoryService.ReadLprEvents`.
public struct ReadLprEventsRequest: Encodable, Sendable {
    public let range: TimeRange
    /// Absent when the search is not limited to cameras or vehicle attributes.
    public let filters: LprSearchFilterArray?
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
        filters: LprSearchFilterArray? = nil,
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(range, forKey: .range)
        if let filters, !filters.filters.isEmpty || filters.vehicleFilters?.isEmpty == false {
            try container.encode(filters, forKey: .filters)
        }
        try container.encodeIfPresent(searchPredicate, forKey: .searchPredicate)
        try container.encodeIfPresent(limit, forKey: .limit)
        if let offset, offset > 0 {
            try container.encode(offset, forKey: .offset)
        }
        try container.encodeIfPresent(nodeDescriptions, forKey: .nodeDescriptions)
        try container.encodeIfPresent(descending, forKey: .descending)
    }
}
