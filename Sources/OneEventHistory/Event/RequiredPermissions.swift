import Foundation

public struct RequiredPermissions: Decodable, Equatable, Sendable {
    public let requiredObjectPermissions: [RequiredObjectPermissions]

    private enum CodingKeys: String, CodingKey {
        case requiredObjectPermissions = "required_object_permissions"
    }
}
