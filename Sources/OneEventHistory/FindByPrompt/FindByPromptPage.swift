import Foundation

/// One SSE chunk from `EventHistoryService.FindByPrompt`.
public struct FindByPromptPage: Decodable, Equatable, Sendable {
    public let items: [SimilarObject]
    public let error: DetectorError?

    private enum CodingKeys: String, CodingKey {
        case items
        case error
    }
}
