import Foundation
import OneWireFormat

/// Time interval for EventHistory queries (`primitive.TimeRange`).
public struct TimeRange: Equatable, Sendable {
    public let begin: Date
    public let end: Date

    public init(begin: Date, end: Date) {
        self.begin = begin
        self.end = end
    }
}

extension TimeRange: Encodable {
    private enum CodingKeys: String, CodingKey {
        case beginTime = "begin_time"
        case endTime = "end_time"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Timestamp.utc.string(from: begin), forKey: .beginTime)
        try container.encode(Timestamp.utc.string(from: end), forKey: .endTime)
    }
}

extension TimeRange: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let beginString = try container.decode(String.self, forKey: .beginTime)
        let endString = try container.decode(String.self, forKey: .endTime)
        guard let begin = Timestamp.utc.date(from: beginString),
              let end = Timestamp.utc.date(from: endString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .beginTime,
                in: container,
                debugDescription: "Invalid ASIP timestamp"
            )
        }
        self.begin = begin
        self.end = end
    }
}
