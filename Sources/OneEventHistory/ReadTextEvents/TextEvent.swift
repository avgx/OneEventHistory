import Foundation
import OneWireFormat

/// POS / text event from `ReadTextEvents`.
public struct TextEvent: Decodable, Equatable, Sendable {
    public let guid: String
    public let timestamp: String
    public let groupID: String?
    public let data: [TextTuple]

    private enum CodingKeys: String, CodingKey {
        case guid
        case timestamp
        case groupID = "group_id"
        case data
    }

    public var timestampDate: Date? {
        Timestamp.utc.date(from: timestamp)
    }

    public var primaryText: String? {
        data.first?.text
    }
}

/// One text tuple inside a ``TextEvent``.
public struct TextTuple: Decodable, Equatable, Sendable {
    public let timestamp: String?
    public let text: String?
    public let json: String?

    public init(timestamp: String? = nil, text: String? = nil, json: String? = nil) {
        self.timestamp = timestamp
        self.text = text
        self.json = json
    }
}
