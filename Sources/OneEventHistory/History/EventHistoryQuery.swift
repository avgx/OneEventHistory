import Foundation
import OneWireFormat

public struct EventHistoryQuery: Equatable, Sendable {
    public var eventTypes: [String]
    public var cameras: [AccessPoint]
    public var detectors: [AccessPoint]

    public init(
        eventTypes: [String] = [],
        cameras: [AccessPoint] = [],
        detectors: [AccessPoint] = []
    ) {
        self.eventTypes = eventTypes
        self.cameras = cameras
        self.detectors = detectors
    }
}

public struct EventHistoryFilterSelection: Equatable, Sendable {
    public var eventTypeIDs: Set<String>
    public var cameras: Set<AccessPoint>
    public var detectors: Set<AccessPoint>

    public init(
        eventTypeIDs: Set<String> = [],
        cameras: Set<AccessPoint> = [],
        detectors: Set<AccessPoint> = []
    ) {
        self.eventTypeIDs = eventTypeIDs
        self.cameras = cameras
        self.detectors = detectors
    }

    public func toQuery() -> EventHistoryQuery {
        EventHistoryQuery(
            eventTypes: eventTypeIDs.sorted(),
            cameras: cameras.sorted(),
            detectors: detectors.sorted()
        )
    }
}
