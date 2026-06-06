import Foundation

/// Stored event category filter value (`EEventType` from Events.proto).
public enum EEventType: String, Codable, Equatable, Sendable, CaseIterable, Identifiable {
    case detectorEvent = "ET_DetectorEvent"
    case stateControlStateChangeEvent = "ET_StateControlStateChangeEvent"
    case cameraChangedEvent = "ET_CameraChangedEvent"
    case commonDeviceChangedEvent = "ET_CommonDeviceChangedEvent"
    case ipDeviceStateChangedEvent = "ET_IpDeviceStateChangedEvent"
    case archiveReplicationProgressEvent = "ET_ArchiveReplicationProgressEvent"
    case layoutsChangedEvent = "ET_LayoutsChangedEvent"
    case mapsChangedEvent = "ET_MapsChangedEvent"
    case mapProviderChangedEvent = "ET_MapProviderChangedEvent"
    case macroEvent = "ET_MacroEvent"
    case storageVolumeHealth = "ET_StorageVolumeHealth"
    case storageRecordState = "ET_StorageRecordState"
    case notificationExternal = "ET_NotificationExternal"
    case ptzEvent = "ET_PTZEvent"
    case bookmark = "ET_Bookmark"
    case alert = "ET_Alert"
    case alertState = "ET_AlertState"
    case cloudBindingChanged = "ET_CloudBindingChanged"
    case hostStatusChangedEvent = "ET_HostStatusChangedEvent"
    case internalHostStatus = "ET_InternalHostStatus"
    case groupMembershipChangedEvent = "ET_GroupMembershipChangedEvent"
    case externalMacroEvent = "ET_ExternalMacroEvent"
    case cameraArmStateEvent = "ET_CameraArmStateEvent"
    case objectActivatedEvent = "ET_ObjectActivatedEvent"
    case controlPanelStateEvent = "ET_ControlPanelStateEvent"
    case sItemStatus = "ET_SItemStatus"
    case loosingVmdaData = "ET_LoosingVmdaData"
    case acfaEvent = "ET_ACFAEvent"
    case serviceLifeEvent = "ET_ServiceLifeEvent"
    case textEvent = "ET_TextEvent"
    case hidEvent = "ET_HidEvent"
    case integrityEvent = "ET_IntegrityEvent"
    case replicationStateEvent = "ET_ReplicationStateEvent"
    case replicationProgressEvent = "ET_ReplicationProgressEvent"
    case audit = "ET_Audit"
    case sensorSignalLevelChanged = "ET_SensorSignalLevelChanged"
    case timeSyncEvent = "ET_TimeSyncEvent"
    case counterEvent = "ET_CounterEvent"
    case videowallStatusEvent = "ET_VideowallStatusEvent"
    case videowallControlDataEvent = "ET_VideowallControlDataEvent"
    case videowallChangeEvent = "ET_VideowallChangeEvent"
    case globalTrackProfileChangedEvent = "ET_GlobalTrackProfileChangedEvent"
    case diagnosticActionEvent = "ET_DiagnosticActionEvent"
    case configChangedEvent = "ET_ConfigChangedEvent"
    case sharedConfigChangedEvent = "ET_SharedConfigChangedEvent"
    case serviceStatus = "ET_ServiceStatus"
    case configLinkageChangedEvent = "ET_ConfigLinkageChangedEvent"
    case systemError = "ET_SystemError"
    case acfaComponentChangedEvent = "ET_AcfaComponentChangedEvent"
    case licenseServiceEvent = "ET_LicenseServiceEvent"
    case componentChangedEvent = "ET_ComponentChangedEvent"
    case rrListChangedEvent = "ET_RRListChangedEvent"
    case archiveChangedEvent = "ET_ArchiveChangedEvent"
    case userLockedEvent = "ET_UserLockedEvent"
    case exportEvent = "ET_ExportEvent"
    case dataStorageSettingsChanged = "ET_DataStorageSettingsChanged"
    case exportSettingsChanged = "ET_ExportSettingsChanged"
    case bookmarkSettingsChanged = "ET_BookmarkSettingsChanged"
    case gdprSettingsChanged = "ET_GDPRSettingsChanged"
    case timeZoneEvent = "ET_TimeZoneEvent"
    case cpuOverloadedEvent = "ET_CpuOverloadedEvent"
    case macroConfigEvent = "ET_MacroConfigEvent"
    case counterConfigEvent = "ET_CounterConfigEvent"
    case bookmarkChangedEvent = "ET_BookmarkChangedEvent"
    case ldapSynchronizationStateChangedEvent = "ET_LDAPSynchronizationStateChangedEvent"
    case arpAgentStateChangedEvent = "ET_ArpAgentStateChangedEvent"

    public var id: String { rawValue }

    /// Short label for UI (principal subtitle, event type sheet).
    public var displayName: String {
        switch self {
        case .detectorEvent: "Detector"
        case .stateControlStateChangeEvent: "State control"
        case .cameraChangedEvent: "Camera changed"
        case .commonDeviceChangedEvent: "Device changed"
        case .ipDeviceStateChangedEvent: "IP device state"
        case .archiveReplicationProgressEvent: "Archive replication"
        case .layoutsChangedEvent: "Layouts changed"
        case .mapsChangedEvent: "Maps changed"
        case .mapProviderChangedEvent: "Map provider changed"
        case .macroEvent: "Macro"
        case .storageVolumeHealth: "Storage volume health"
        case .storageRecordState: "Storage record state"
        case .notificationExternal: "External notification"
        case .ptzEvent: "PTZ"
        case .bookmark: "Bookmark"
        case .alert: "Alert"
        case .alertState: "Alert state"
        case .cloudBindingChanged: "Cloud binding"
        case .hostStatusChangedEvent: "Host status"
        case .internalHostStatus: "Internal host status"
        case .groupMembershipChangedEvent: "Group membership"
        case .externalMacroEvent: "External macro"
        case .cameraArmStateEvent: "Camera arm state"
        case .objectActivatedEvent: "Object activated"
        case .controlPanelStateEvent: "Control panel"
        case .sItemStatus: "Item status"
        case .loosingVmdaData: "Losing VMDA data"
        case .acfaEvent: "ACFA"
        case .serviceLifeEvent: "Service life"
        case .textEvent: "Text"
        case .hidEvent: "HID"
        case .integrityEvent: "Integrity"
        case .replicationStateEvent: "Replication state"
        case .replicationProgressEvent: "Replication progress"
        case .audit: "Audit"
        case .sensorSignalLevelChanged: "Sensor signal level"
        case .timeSyncEvent: "Time sync"
        case .counterEvent: "Counter"
        case .videowallStatusEvent: "Videowall status"
        case .videowallControlDataEvent: "Videowall control"
        case .videowallChangeEvent: "Videowall change"
        case .globalTrackProfileChangedEvent: "Track profile changed"
        case .diagnosticActionEvent: "Diagnostic action"
        case .configChangedEvent: "Config changed"
        case .sharedConfigChangedEvent: "Shared config changed"
        case .serviceStatus: "Service status"
        case .configLinkageChangedEvent: "Config linkage changed"
        case .systemError: "System error"
        case .acfaComponentChangedEvent: "ACFA component changed"
        case .licenseServiceEvent: "License service"
        case .componentChangedEvent: "Component changed"
        case .rrListChangedEvent: "RR list changed"
        case .archiveChangedEvent: "Archive changed"
        case .userLockedEvent: "User locked"
        case .exportEvent: "Export"
        case .dataStorageSettingsChanged: "Data storage settings"
        case .exportSettingsChanged: "Export settings"
        case .bookmarkSettingsChanged: "Bookmark settings"
        case .gdprSettingsChanged: "GDPR settings"
        case .timeZoneEvent: "Time zone"
        case .cpuOverloadedEvent: "CPU overloaded"
        case .macroConfigEvent: "Macro config"
        case .counterConfigEvent: "Counter config"
        case .bookmarkChangedEvent: "Bookmark changed"
        case .ldapSynchronizationStateChangedEvent: "LDAP sync"
        case .arpAgentStateChangedEvent: "ARP agent state"
        }
    }

    /// Types shown in the default "User events" section of the event type sheet.
    public var isUserFacing: Bool {
        switch self {
        case .detectorEvent, .stateControlStateChangeEvent, .macroEvent, .bookmark, .alert, .alertState,
             .textEvent, .ptzEvent, .notificationExternal, .externalMacroEvent, .acfaEvent, .counterEvent,
             .exportEvent, .audit, .hidEvent, .integrityEvent, .cameraArmStateEvent, .objectActivatedEvent,
             .controlPanelStateEvent, .diagnosticActionEvent:
            true
        default:
            false
        }
    }

    /// Protobuf message name when applicable (`event.event_name` prefix).
    public var eventName: String? {
        switch self {
        case .detectorEvent: "axxonsoft.bl.events.DetectorEvent"
        case .stateControlStateChangeEvent: "axxonsoft.bl.events.StateControlStateChangeEvent"
        case .macroEvent: "axxonsoft.bl.events.MacroEvent"
        case .bookmark: "axxonsoft.bl.events.Bookmark"
        case .alert: "axxonsoft.bl.events.Alert"
        case .alertState: "axxonsoft.bl.events.AlertState"
        case .textEvent: "axxonsoft.bl.events.TextEvent"
        default: nil
        }
    }

    public static var userFacingCases: [EEventType] {
        allCases.filter(\.isUserFacing)
    }

    public static var systemCases: [EEventType] {
        allCases.filter { !$0.isUserFacing }
    }
}
