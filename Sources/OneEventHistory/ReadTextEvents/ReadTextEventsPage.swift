import Foundation

/// One SSE chunk from `EventHistoryService.ReadTextEvents`.
public struct ReadTextEventsPage: Decodable, Equatable, Sendable {
    public let items: [TextEvent]
    public let unreachableSubjects: [String]?
    public let nextOffset: Int?

    private enum CodingKeys: String, CodingKey {
        case items
        case unreachableSubjects = "unreachable_subjects"
        case nextOffset = "next_offset"
    }
}
