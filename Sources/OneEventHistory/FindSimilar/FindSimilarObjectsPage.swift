import Foundation

/// One SSE chunk from `FindSimilarObjects` / `FindSimilarObjects2`.
public struct FindSimilarObjectsPage: Decodable, Equatable, Sendable {
    public let items: [SimilarObject]
    public let error: DetectorError?
    public let nextOffset: Int?

    private enum CodingKeys: String, CodingKey {
        case items
        case error
        case nextOffset = "next_offset"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([SimilarObject].self, forKey: .items)
        error = try container.decodeIfPresent(DetectorError.self, forKey: .error)
        nextOffset = try EventHistoryNextOffset.decode(from: container, forKey: .nextOffset)
    }
}
