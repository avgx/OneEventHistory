import Foundation

/// Node target for fan-out EventHistory queries (`NodeDescription`).
public struct NodeDescription: Codable, Equatable, Sendable {
    public let nodeName: String

    private enum CodingKeys: String, CodingKey {
        case nodeName = "node_name"
    }

    public init(nodeName: String) {
        self.nodeName = nodeName
    }
}
