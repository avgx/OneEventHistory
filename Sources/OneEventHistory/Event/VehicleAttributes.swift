import Foundation

/// Vehicle class. `1` is `car`. `unknown` is not shown.
///
/// Display strings are in EventL10n, copied from VMS `StringResources` (`EVehicleClass_*`).
public enum VehicleClass: Int, CaseIterable, Hashable, Sendable {
    case unknown = 0
    case car
    case truck
    case bus
    case motorcycle
    case lightCommercialVehicle
    case trolleybus
    case tram
    case vanVehicle
    case miniVanVehicle
    case suv
    case pickup
    case average
    case largeVehicle
    case megaLarge
    case specialTransport
    case dumpTruck
    case sedan
}

/// Travel direction. `0` is unknown, `1` is incoming, `2` is outgoing.
///
/// Display strings are in EventL10n, copied from VMS `StringResources` (`LPRSearchRuleView_VehicleDirection*`).
public enum Direction: Int, CaseIterable, Hashable, Sendable {
    case unknown = 0
    case incoming
    case outgoing
}

/// Headlights. Not a boolean: `0` undefined, `1` enabled, `2` disabled.
///
/// Display strings are in EventL10n, copied from VMS `StringResources` (`LPRSearchRuleView_VehicleHeadlights*`).
public enum HeadlightsStatus: Int, CaseIterable, Hashable, Sendable {
    case undefined = 0
    case enabled
    case disabled
}
