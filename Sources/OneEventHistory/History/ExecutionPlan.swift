import Foundation
import OneWireFormat

public struct ClientConstraints: Equatable, Sendable {
    public var cameras: [AccessPoint]
    public var detectors: [AccessPoint]
    public var eventTypes: [String]

    public init(
        cameras: [AccessPoint] = [],
        detectors: [AccessPoint] = [],
        eventTypes: [String] = []
    ) {
        self.cameras = cameras
        self.detectors = detectors
        self.eventTypes = eventTypes
    }

    public var isEmpty: Bool {
        cameras.isEmpty && detectors.isEmpty && eventTypes.isEmpty
    }
}

public struct ExecutionPlan: Equatable, Sendable {
    public let serverFilters: SearchFilterArray
    public let clientConstraints: ClientConstraints
    public let publicReason: String?

    public var requiresClientFiltering: Bool {
        !clientConstraints.isEmpty
    }

    public static func build(query: EventHistoryQuery, cameras: [AccessPoint]) -> ExecutionPlan {
        var client = ClientConstraints()
        var reason: String?

        if !query.detectors.isEmpty {
            client.detectors = query.detectors
            reason = "Detector filter is applied on device"
        }

        let nodes = Set(query.cameras.map(nodeKey(for:)))
        let serverSubjects: [AccessPoint]
        if query.cameras.isEmpty {
            serverSubjects = []
        } else if nodes.count == 1 {
            serverSubjects = query.cameras
        } else {
            serverSubjects = []
            client.cameras = query.cameras
            reason = "Cameras span multiple nodes"
        }

        let serverFilter = SearchFilter(
            type: .detectorEvent,
            subjects: serverSubjects,
            values: query.eventTypes
        )
        let filters = (query.eventTypes.isEmpty && serverSubjects.isEmpty && query.detectors.isEmpty)
            ? SearchFilterArray(filters: [])
            : SearchFilterArray(filters: [serverFilter])

        return ExecutionPlan(
            serverFilters: filters,
            clientConstraints: client,
            publicReason: reason
        )
    }

    private static func nodeKey(for accessPoint: AccessPoint) -> String {
        let parts = accessPoint.split(separator: "/")
        if parts.count >= 2, parts[0] == "hosts" {
            return "\(parts[0])/\(parts[1])"
        }
        return accessPoint
    }
}
