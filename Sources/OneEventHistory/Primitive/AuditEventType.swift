import Foundation
import SafeEnum

/// Audit operation type (`AuditEvent.EAuditEventType` in `Events.proto`).
///
/// Use with ``SearchFilter/audit(operations:subjects:)`` when reading `ET_Audit` via EventHistory.
public enum AuditEventType: String, Codable, Hashable, Sendable, CaseIterable {
    case notSpecified = "AE_NOT_SPECIFIED"

    case userAdd = "AE_USER_ADD"
    case userRemove = "AE_USER_REMOVE"
    case userSetup = "AE_USER_SETUP"
    case roleAdd = "AE_ROLE_ADD"
    case roleRemove = "AE_ROLE_REMOVE"
    case roleSetup = "AE_ROLE_SETUP"
    case userLogin = "AE_USER_LOGIN"
    case userLogout = "AE_USER_LOGOUT"
    case deviceAdd = "AE_DEVICE_ADD"
    case deviceRemove = "AE_DEVICE_REMOVE"
    case deviceSetup = "AE_DEVICE_SETUP"
    case detectorAdd = "AE_DETECTOR_ADD"
    case detectorRemove = "AE_DETECTOR_REMOVE"
    case detectorSetup = "AE_DETECTOR_SETUP"
    case archiveAdd = "AE_ARCHIVE_ADD"
    case archiveRemove = "AE_ARCHIVE_REMOVE"
    case archiveSetup = "AE_ARCHIVE_SETUP"
    case ruleAdd = "AE_RULE_ADD"
    case ruleRemove = "AE_RULE_REMOVE"
    case ruleSetup = "AE_RULE_SETUP"
    case alertModeSetup = "AE_ALERT_MODE_SETUP"
    case zoneArmed = "AE_ZONE_ARMED"
    case zoneDisarmed = "AE_ZONE_DISARMED"
    case mmExport = "AE_MMEXPORT"
    case notifierAdd = "AE_NOTIFIER_ADD"
    case notifierRemove = "AE_NOTIFIER_REMOVE"
    case notifierSetup = "AE_NOTIFIER_SETUP"
    case generalSetup = "AE_GENERAL_SETUP"
    case archiveBindingSetup = "AE_ARCHIVE_BINDING_SETUP"
    case mmExportAgentAdd = "AE_MMEXPORTAGENT_ADD"
    case mmExportAgentRemove = "AE_MMEXPORTAGENT_REMOVE"
    case mmExportAgentSetup = "AE_MMEXPORTAGENT_SETUP"
    case macroAdd = "AE_MACRO_ADD"
    case macroRemove = "AE_MACRO_REMOVE"
    case macroSetup = "AE_MACRO_SETUP"
    case alertTaking = "AE_ALERT_TAKING"
    case alertDangerous = "AE_ALERT_DANGEROUS"
    case alertSuspicious = "AE_ALERT_SUSPICIOUS"
    case alertFalse = "AE_ALERT_FALSE"
    case nodeIncluded = "AE_NODE_INCLUDED"
    case nodeExcluded = "AE_NODE_EXCLUDED"
    case archiveViewing = "AE_ARCHIVE_VIEWING"
    case cameraViewing = "AE_CAMERA_VIEWING"
    case layoutViewing = "AE_LAYOUT_VIEWING"
    case journalExport = "AE_JOURNAL_EXPORT"
    case ldapAdd = "AE_LDAP_ADD"
    case ldapRemove = "AE_LDAP_REMOVE"
    case ldapSetup = "AE_LDAP_SETUP"
    case layoutAdd = "AE_LAYOUT_ADD"
    case layoutRemove = "AE_LAYOUT_REMOVE"
    case layoutSetup = "AE_LAYOUT_SETUP"
    case userLoginFailed = "AE_USER_LOGIN_FAILED"
    case ptzControl = "AE_PTZ_CONTROL"
    case archiveCommentAdd = "AE_ARCHIVE_COMMENT_ADD"
    case archiveCommentEdit = "AE_ARCHIVE_COMMENT_EDIT"
    case counterAdd = "AE_COUNTER_ADD"
    case counterRemove = "AE_COUNTER_REMOVE"
    case counterSetup = "AE_COUNTER_SETUP"
    case alertPostpone = "AE_ALERT_POSTPONE"
    case revisionReset = "AE_REVISION_RESET"
    case backupApplied = "AE_BACKUP_APPLIED"
    case archiveReplicationSetup = "AE_ARCHIVE_REPLICATION_SETUP"
    case templateBinding = "AE_TEMPLATE_BINDING"
    case templateUnbinding = "AE_TEMPLATE_UNBINDING"
    case includeCameraInGroup = "AE_INCLUDE_CAMERA_IN_GROUP"
    case excludeCameraFromGroup = "AE_EXCLUDE_CAMERA_FROM_GROUP"
    case archiveIntervalRemove = "AE_ARCHIVE_INTERVAL_REMOVE"
    case bookmarkAdded = "AE_BOOKMARK_ADDED"
    case bookmarkChanged = "AE_BOOKMARK_CHANGED"
    case bookmarkRemoved = "AE_BOOKMARK_REMOVED"
    case bookmarkExported = "AE_BOOKMARK_EXPORTED"
    case ldapSynchronizationStarted = "AE_LDAP_SYNCHRONIZATION_STARTED"
    case ldapSynchronizationStopped = "AE_LDAP_SYNCHRONIZATION_STOPPED"
    case userRoleAssignmentAdded = "AE_USER_ROLE_ASSIGNMENT_ADDED"
    case userRoleAssignmentRemoved = "AE_USER_ROLE_ASSIGNMENT_REMOVED"
    case deviceReset = "AE_DEVICE_RESET"
    case includeComponentInGroup = "AE_INCLUDE_COMPONENT_IN_GROUP"
    case excludeComponentFromGroup = "AE_EXCLUDE_COMPONENT_FROM_GROUP"
    case systemJournalRetentionPeriodSetup = "AE_SYSTEM_JOURNAL_RETENTION_PERIOD_SETUP"
    case systemJournalCleanupPeriodSetup = "AE_SYSTEM_JOURNAL_CLEANUP_PERIOD_SETUP"
}

/// Forward-compatible audit operation wire value.
public typealias AuditEventTypeValue = SafeEnum<AuditEventType>

public extension AuditEventType {
    /// Short label for filter UI (proto name without `AE_` prefix).
    var displayName: String {
        String(rawValue.dropFirst(3)).replacingOccurrences(of: "_", with: " ").capitalized
    }

    /// Proto numeric id (`EAuditEventType` in `Events.proto`) when known.
    var wireNumber: Int? {
        Self.wireNumbers[self]
    }

    /// Cases useful for audit filter UI (excludes ``notSpecified``).
    static var filterCases: [AuditEventType] {
        allCases.filter { $0 != .notSpecified }
    }

    private static let wireNumbers: [AuditEventType: Int] = [
        .notSpecified: 0,
        .userAdd: 7, .userRemove: 8, .userSetup: 9,
        .roleAdd: 10, .roleRemove: 11, .roleSetup: 12,
        .userLogin: 13, .userLogout: 14,
        .deviceAdd: 15, .deviceRemove: 16, .deviceSetup: 17,
        .detectorAdd: 18, .detectorRemove: 19, .detectorSetup: 20,
        .archiveAdd: 21, .archiveRemove: 22, .archiveSetup: 23,
        .ruleAdd: 24, .ruleRemove: 25, .ruleSetup: 26,
        .alertModeSetup: 27, .zoneArmed: 28, .zoneDisarmed: 29,
        .mmExport: 30,
        .notifierAdd: 31, .notifierRemove: 32, .notifierSetup: 33,
        .generalSetup: 34, .archiveBindingSetup: 35,
        .mmExportAgentAdd: 36, .mmExportAgentRemove: 37, .mmExportAgentSetup: 38,
        .macroAdd: 39, .macroRemove: 40, .macroSetup: 41,
        .alertTaking: 42, .alertDangerous: 43, .alertSuspicious: 44, .alertFalse: 45,
        .nodeIncluded: 47, .nodeExcluded: 48,
        .archiveViewing: 49, .cameraViewing: 50, .layoutViewing: 51,
        .journalExport: 55,
        .ldapAdd: 56, .ldapRemove: 57, .ldapSetup: 58,
        .layoutAdd: 59, .layoutRemove: 60, .layoutSetup: 61,
        .userLoginFailed: 62, .ptzControl: 63,
        .archiveCommentAdd: 64, .archiveCommentEdit: 65,
        .counterAdd: 74, .counterRemove: 75, .counterSetup: 76,
        .alertPostpone: 77, .revisionReset: 78, .backupApplied: 79,
        .archiveReplicationSetup: 80,
        .templateBinding: 81, .templateUnbinding: 82,
        .includeCameraInGroup: 83, .excludeCameraFromGroup: 84,
        .archiveIntervalRemove: 85,
        .bookmarkAdded: 86, .bookmarkChanged: 87, .bookmarkRemoved: 88, .bookmarkExported: 89,
        .ldapSynchronizationStarted: 90, .ldapSynchronizationStopped: 91,
        .userRoleAssignmentAdded: 92, .userRoleAssignmentRemoved: 93,
        .deviceReset: 94,
        .includeComponentInGroup: 95, .excludeComponentFromGroup: 96,
        .systemJournalRetentionPeriodSetup: 97, .systemJournalCleanupPeriodSetup: 98,
    ]
}
