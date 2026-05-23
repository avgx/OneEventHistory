import Foundation

/// Request body for `EventHistoryService.FindByPrompt`.
public struct FindByPromptRequest: Encodable, Sendable {
    public let prompt: String
    public let range: TimeRange
    public let minimalScore: Double
    public let originIds: [String]
    public let filters: FieldsFilterArray?
    public let nodeDescriptions: [NodeDescription]?

    private enum CodingKeys: String, CodingKey {
        case prompt
        case range
        case minimalScore = "minimal_score"
        case originIds = "origin_ids"
        case filters
        case nodeDescriptions = "node_descriptions"
    }

    public init(
        prompt: String,
        range: TimeRange,
        minimalScore: Double,
        originIds: [String],
        filters: FieldsFilterArray? = nil,
        nodeDescriptions: [NodeDescription]? = nil
    ) {
        self.prompt = prompt
        self.range = range
        self.minimalScore = minimalScore
        self.originIds = originIds
        self.filters = filters
        self.nodeDescriptions = nodeDescriptions
    }
}
