import Foundation

/// ReadAlerts filter (`AlertsSearchFilter`).
public struct AlertsSearchFilter: Codable, Equatable, Sendable {
    public let subjects: [String]
    public let values: [String]
    public let texts: [String]?

    public init(subjects: [String], values: [String] = [], texts: [String]? = nil) {
        self.subjects = subjects
        self.values = values
        self.texts = texts
    }
}

/// Wrapper for repeated ReadAlerts filters (`AlertsSearchFilterArray`).
public struct AlertsSearchFilterArray: Codable, Equatable, Sendable {
    public let filters: [AlertsSearchFilter]

    public init(filters: [AlertsSearchFilter]) {
        self.filters = filters
    }
}
