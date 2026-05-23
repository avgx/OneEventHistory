import Foundation

/// JSON envelope for gRPC gateway calls via `POST /grpc`.
///
/// Example: `{ "method": "axxonsoft.bl.events.EventHistoryService.ReadEvents", "data": { ... } }`
public struct GrpcEnvelope<Payload: Encodable & Sendable>: Encodable, Sendable {
    public let method: String
    public let data: Payload

    public init(method: String, data: Payload) {
        self.method = method
        self.data = data
    }
}
