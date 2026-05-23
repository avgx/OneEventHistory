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
}
