import Foundation
import OneWireFormat

/// ReadBookmarks filter (`BookmarkSearchFilter`).
public struct BookmarkSearchFilter: Codable, Equatable, Sendable {
    public let subjects: [AccessPoint]
    public let commentText: String?

    private enum CodingKeys: String, CodingKey {
        case subjects
        case commentText = "comment_text"
    }

    public init(subjects: [AccessPoint] = [], commentText: String? = nil) {
        self.subjects = subjects
        self.commentText = commentText
    }
}
