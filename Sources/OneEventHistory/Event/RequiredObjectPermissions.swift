import Foundation

public struct RequiredObjectPermissions: Decodable, Equatable, Sendable {
    public let accessPoint: String
    public let cameraAccess: String

    private enum CodingKeys: String, CodingKey {
        case accessPoint = "access_point"
        case cameraAccess = "camera_access"
    }
}
