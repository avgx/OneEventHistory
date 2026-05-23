import Foundation
import OneWireFormat

/// Image or timestamp reference for similarity search (`FindSimilarObjectsRequest.data` oneof).
public enum SimilarityQuery: Equatable, Sendable {
    case jpegBase64(String)
    case timestamp(Date)

    /// ASIP wire value for timestamp-based similarity search.
    public var timestampWireValue: String? {
        guard case .timestamp(let date) = self else { return nil }
        return Timestamp.utc.string(from: date)
    }
}

extension SimilarityQuery: Encodable {
    private enum CodingKeys: String, CodingKey {
        case jpegImage = "jpeg_image"
        case timestamp
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .jpegBase64(let value):
            try container.encode(value, forKey: .jpegImage)
        case .timestamp(let date):
            try container.encode(Timestamp.utc.string(from: date), forKey: .timestamp)
        }
    }
}
