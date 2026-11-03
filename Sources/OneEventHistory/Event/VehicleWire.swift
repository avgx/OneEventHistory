import Foundation

extension VehicleClass {
    /// Protobuf name sent inside `{"value": ...}`.
    ///
    /// Desktop and the web client use these names (`Car`, `VehicleClassUnknown`).
    /// `String(describing:)` is `car`, and the gateway does not match that.
    public var wireValue: String {
        switch self {
        case .unknown:
            return "VehicleClassUnknown"
        default:
            let name = String(describing: self)
            return name.prefix(1).uppercased() + name.dropFirst()
        }
    }

    public init?(wire: String) {
        guard let match = Self.allCases.first(where: { $0.wireValue == wire }) else { return nil }
        self = match
    }
}

extension Direction {
    /// Protobuf name sent inside `{"value": ...}` (`Incoming`, `Outgoing`, `Unknown`).
    public var wireValue: String {
        switch self {
        case .unknown: return "Unknown"
        case .incoming: return "Incoming"
        case .outgoing: return "Outgoing"
        }
    }

    public init?(wire: String) {
        guard let match = Self.allCases.first(where: { $0.wireValue == wire }) else { return nil }
        self = match
    }
}

extension VehiclePurpose {
    /// Protobuf name sent inside `{"value": ...}` (`FireTrucks`, `Police`, `Ambulance`).
    public var wireValue: String {
        switch self {
        case .unknown: return "Unknown"
        case .fireTrucks: return "FireTrucks"
        case .police: return "Police"
        case .ambulance: return "Ambulance"
        }
    }

    public init?(wire: String) {
        guard let match = Self.allCases.first(where: { $0.wireValue == wire }) else { return nil }
        self = match
    }
}

extension HeadlightsStatus {
    /// Protobuf name sent inside `{"value": ...}` (`Enabled`, `Disabled`, `Undefined`).
    public var wireValue: String {
        switch self {
        case .undefined: return "Undefined"
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }

    public init?(wire: String) {
        guard let match = Self.allCases.first(where: { $0.wireValue == wire }) else { return nil }
        self = match
    }
}
