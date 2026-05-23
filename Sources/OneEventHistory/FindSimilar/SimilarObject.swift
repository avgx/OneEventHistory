import Foundation

/// Similarity search result item (`SimilarObject`).
public struct SimilarObject: Decodable, Equatable, Sendable {
    public let event: EventBody
    public let score: Double
}
