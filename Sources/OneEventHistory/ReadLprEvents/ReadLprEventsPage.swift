import Foundation

/// One SSE chunk from `EventHistoryService.ReadLprEvents`.
public struct ReadLprEventsPage: Decodable, Equatable, Sendable {
    public let items: [Event]
    public let unreachableSubjects: [String]?
    public let nextOffset: Int?

    private enum CodingKeys: String, CodingKey {
        case items
        case unreachableSubjects = "unreachable_subjects"
        case nextOffset = "next_offset"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Event].self, forKey: .items)
        unreachableSubjects = try container.decodeIfPresent([String].self, forKey: .unreachableSubjects)
        nextOffset = try EventHistoryNextOffset.decode(from: container, forKey: .nextOffset)
    }
}
