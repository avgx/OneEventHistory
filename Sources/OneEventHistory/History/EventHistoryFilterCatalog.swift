import Foundation
import OneDomain
import OneWireFormat

public struct EventTypeOption: Identifiable, Hashable, Sendable {
    public var id: String { eventTypeID }
    public let eventTypeID: String
    public let name: String

    public init(eventTypeID: String, name: String) {
        self.eventTypeID = eventTypeID
        self.name = name
    }
}

public struct EventHistoryFilterCatalog: Sendable {
    public static let defaultIgnored: Set<String> = [
        "MotionMask",
        "TargetList",
        "BinaryMask",
        "ObjectCountMask",
        "QueueMask",
        "ColorMask",
        "PrivateMask",
        "SmokeMask",
        "HumanBoneTargetList",
        "ObjectDescriptorEvent",
    ]

    private struct Edge: Hashable {
        let camera: AccessPoint
        let detector: AccessPoint
        let eventTypeID: String
        let eventName: String
    }

    private let edges: [Edge]
    public let allCameras: [Camera]
    public let allDetectors: [Detector]
    public let allEventTypes: [EventTypeOption]

    public init(cameras: [Camera], ignoredEventTypeIDs: Set<String> = Self.defaultIgnored) {
        self.allCameras = cameras.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }

        var edgeList: [Edge] = []
        var detectorsByID: [AccessPoint: Detector] = [:]
        var typeNames: [String: String] = [:]

        for camera in cameras {
            let detectors = (camera.detectors ?? []) + (camera.offlineDetectors ?? [])
            for detector in detectors {
                detectorsByID[detector.accessPoint] = detector
                for event in detector.events where !ignoredEventTypeIDs.contains(event.id) {
                    edgeList.append(
                        Edge(
                            camera: camera.accessPoint,
                            detector: detector.accessPoint,
                            eventTypeID: event.id,
                            eventName: event.name
                        )
                    )
                    typeNames[event.id] = event.name
                }
            }
        }

        self.edges = edgeList
        self.allDetectors = detectorsByID.values.sorted {
            $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }
        self.allEventTypes = typeNames
            .map { EventTypeOption(eventTypeID: $0.key, name: $0.value) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public func availableEventTypes(for selection: EventHistoryFilterSelection) -> [EventTypeOption] {
        let filtered = edges(matching: selection, excluding: .eventTypes)
        let ids = Set(filtered.map(\.eventTypeID))
        return allEventTypes.filter { ids.contains($0.eventTypeID) }
    }

    public func availableCameras(for selection: EventHistoryFilterSelection) -> [Camera] {
        let allowed = Set(edges(matching: selection, excluding: .cameras).map(\.camera))
        return allCameras.filter { allowed.contains($0.accessPoint) }
    }

    public func availableDetectors(for selection: EventHistoryFilterSelection) -> [Detector] {
        let allowed = Set(edges(matching: selection, excluding: .detectors).map(\.detector))
        return allDetectors.filter { allowed.contains($0.accessPoint) }
    }

    public func pruned(_ selection: EventHistoryFilterSelection) -> EventHistoryFilterSelection {
        var result = selection
        let allowedTypes = Set(availableEventTypes(for: selection).map(\.eventTypeID))
        let allowedCameras = Set(availableCameras(for: selection).map(\.accessPoint))
        let allowedDetectors = Set(availableDetectors(for: selection).map(\.accessPoint))
        result.eventTypeIDs = result.eventTypeIDs.intersection(allowedTypes)
        result.cameras = result.cameras.intersection(allowedCameras)
        result.detectors = result.detectors.intersection(allowedDetectors)
        return result
    }

    private enum ExcludedAxis {
        case eventTypes, cameras, detectors
    }

    private func edges(matching selection: EventHistoryFilterSelection, excluding: ExcludedAxis) -> [Edge] {
        edges.filter { edge in
            if excluding != .eventTypes, !selection.eventTypeIDs.isEmpty, !selection.eventTypeIDs.contains(edge.eventTypeID) {
                return false
            }
            if excluding != .cameras, !selection.cameras.isEmpty, !selection.cameras.contains(edge.camera) {
                return false
            }
            if excluding != .detectors, !selection.detectors.isEmpty, !selection.detectors.contains(edge.detector) {
                return false
            }
            return true
        }
    }
}
