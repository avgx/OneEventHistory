import Foundation

/// Metadata field filter for similarity and prompt search (`FieldFilter`).
public struct FieldFilter: Codable, Equatable, Sendable {
    public let fullPathToField: String
    public let valueString: String?
    public let valueRange: ValueRange?

    public struct ValueRange: Codable, Equatable, Sendable {
        public let begin: Double
        public let end: Double

        public init(begin: Double, end: Double) {
            self.begin = begin
            self.end = end
        }
    }

    private enum CodingKeys: String, CodingKey {
        case fullPathToField = "full_path_to_field"
        case valueString = "value_string"
        case valueRange = "value_range"
    }

    public init(fullPathToField: String, valueString: String) {
        self.fullPathToField = fullPathToField
        self.valueString = valueString
        self.valueRange = nil
    }

    public init(fullPathToField: String, valueRange: ValueRange) {
        self.fullPathToField = fullPathToField
        self.valueString = nil
        self.valueRange = valueRange
    }
}

/// Collection of metadata field filters (`FieldsFilterArray`).
public struct FieldsFilterArray: Codable, Equatable, Sendable {
    public let filters: [FieldFilter]

    public init(filters: [FieldFilter]) {
        self.filters = filters
    }
}
