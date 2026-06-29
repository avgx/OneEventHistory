import Foundation

public struct RequiredObjectPermissions: Codable, Equatable, Sendable {
    public let accessPoint: String
    public let cameraAccess: String?
    public let archiveAccess: String?

    private enum CodingKeys: String, CodingKey {
        case accessPoint = "access_point"
        case cameraAccess = "camera_access"
        case archiveAccess = "archive_access"
    }
}
