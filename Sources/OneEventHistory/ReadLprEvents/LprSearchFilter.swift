import Foundation

/// ReadLprEvents filter (`LprSearchFilter`).
public struct LprSearchFilter: Codable, Equatable, Sendable {
    public let subjects: [String]
    public let values: [String]
    public let texts: [String]?

    public init(subjects: [String], values: [String] = [], texts: [String]? = nil) {
        self.subjects = subjects
        self.values = values
        self.texts = texts
    }

    private enum CodingKeys: String, CodingKey {
        case subjects
        case values
        case texts
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subjects, forKey: .subjects)
        if !values.isEmpty {
            try container.encode(values, forKey: .values)
        }
        if let texts, !texts.isEmpty {
            try container.encode(texts, forKey: .texts)
        }
    }
}

/// Wrapper for repeated ReadLprEvents filters (`LprSearchFilterArray`).
public struct LprSearchFilterArray: Codable, Equatable, Sendable {
    public let filters: [LprSearchFilter]
    public let vehicleFilters: [VehicleSearchFilter]?

    private enum CodingKeys: String, CodingKey {
        case filters
        case vehicleFilters = "vehicle_filters"
    }

    public init(filters: [LprSearchFilter], vehicleFilters: [VehicleSearchFilter]? = nil) {
        self.filters = filters
        self.vehicleFilters = vehicleFilters
    }
}
