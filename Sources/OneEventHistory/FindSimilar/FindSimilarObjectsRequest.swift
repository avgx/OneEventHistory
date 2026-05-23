import Foundation

/// Request body for `FindSimilarObjects` / `FindSimilarObjects2`.
public struct FindSimilarObjectsRequest: Encodable, Sendable {
    public let session: UInt64?
    public let isFace: Bool
    public let range: TimeRange
    public let minimalScore: Double
    public let objectIds: [String]?
    public let originIds: [String]
    public let query: SimilarityQuery?
    public let limit: Int?
    public let offset: Int?
    public let nodeDescriptions: [NodeDescription]?
    public let filters: FieldsFilterArray?

    private enum CodingKeys: String, CodingKey {
        case session
        case isFace = "is_face"
        case range
        case minimalScore = "minimal_score"
        case objectIds = "object_ids"
        case originIds = "origin_ids"
        case limit
        case offset
        case nodeDescriptions = "node_descriptions"
        case filters
    }

    public init(
        isFace: Bool,
        range: TimeRange,
        minimalScore: Double,
        originIds: [String],
        query: SimilarityQuery? = nil,
        session: UInt64? = nil,
        objectIds: [String]? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        nodeDescriptions: [NodeDescription]? = nil,
        filters: FieldsFilterArray? = nil
    ) {
        self.session = session
        self.isFace = isFace
        self.range = range
        self.minimalScore = minimalScore
        self.objectIds = objectIds
        self.originIds = originIds
        self.query = query
        self.limit = limit
        self.offset = offset
        self.nodeDescriptions = nodeDescriptions
        self.filters = filters
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(session, forKey: .session)
        try container.encode(isFace, forKey: .isFace)
        try container.encode(range, forKey: .range)
        try container.encode(minimalScore, forKey: .minimalScore)
        try container.encodeIfPresent(objectIds, forKey: .objectIds)
        try container.encode(originIds, forKey: .originIds)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(nodeDescriptions, forKey: .nodeDescriptions)
        try container.encodeIfPresent(filters, forKey: .filters)
        try query?.encode(to: encoder)
    }
}
