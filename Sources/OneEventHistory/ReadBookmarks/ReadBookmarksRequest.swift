import Foundation

/// Request body for `EventHistoryService.ReadBookmarks`.
public struct ReadBookmarksRequest: Encodable, Sendable {
    public let range: TimeRange
    public let filter: BookmarkSearchFilter
    public let limit: Int?
    public let offset: Int?
    public let nodeDescriptions: [NodeDescription]?
    public let descending: Bool?

    private enum CodingKeys: String, CodingKey {
        case range
        case filter
        case limit
        case offset
        case nodeDescriptions = "node_descriptions"
        case descending
    }

    public init(
        range: TimeRange,
        filter: BookmarkSearchFilter,
        limit: Int? = nil,
        offset: Int? = nil,
        nodeDescriptions: [NodeDescription]? = nil,
        descending: Bool? = nil
    ) {
        self.range = range
        self.filter = filter
        self.limit = limit
        self.offset = offset
        self.nodeDescriptions = nodeDescriptions
        self.descending = descending
    }
}
