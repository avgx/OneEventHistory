import Foundation
import OneWireFormat

/// ReadTextEvents filter (`SearchTextFilter`).
public struct SearchTextFilter: Codable, Equatable, Sendable {
    public let subjects: [AccessPoint]
    public let texts: [String]
    public let filterContainingTextParts: Bool?

    private enum CodingKeys: String, CodingKey {
        case subjects
        case texts
        case filterContainingTextParts = "filter_containing_text_parts"
    }

    public init(
        subjects: [AccessPoint] = [],
        texts: [String] = [],
        filterContainingTextParts: Bool? = nil
    ) {
        self.subjects = subjects
        self.texts = texts
        self.filterContainingTextParts = filterContainingTextParts
    }
}

/// Wrapper for repeated ReadTextEvents filters (`SearchTextFilterArray`).
public struct SearchTextFilterArray: Codable, Equatable, Sendable {
    public let filters: [SearchTextFilter]

    public init(filters: [SearchTextFilter]) {
        self.filters = filters
    }
}
