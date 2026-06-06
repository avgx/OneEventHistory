import Foundation

/// One SSE chunk from `EventHistoryService.ReadBookmarks`.
public struct ReadBookmarksPage: Decodable, Equatable, Sendable {
    public let items: [Event]
    public let unreachableSubjects: [String]?
    public let nextOffset: Int?

    private enum CodingKeys: String, CodingKey {
        case items
        case unreachableSubjects = "unreachable_subjects"
        case nextOffset = "next_offset"
    }
}
