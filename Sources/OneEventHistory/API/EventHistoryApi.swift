import Foundation
import OneWireFormat
import RequestResponse

/// EventHistory API (Native BL `EventHistoryService` via `POST /grpc` + SSE).
///
/// Source: [EventHistory.proto](https://github.com/jerrygergov/axxon-telegram-vms/blob/main/support/protos/axxonsoft/bl/events/EventHistory.proto)
public enum EventHistoryApi {
    public static let readEventsMethod = "axxonsoft.bl.events.EventHistoryService.ReadEvents"
    public static let readAlertsMethod = "axxonsoft.bl.events.EventHistoryService.ReadAlerts"
    public static let readLprEventsMethod = "axxonsoft.bl.events.EventHistoryService.ReadLprEvents"
    public static let findSimilarObjectsMethod = "axxonsoft.bl.events.EventHistoryService.FindSimilarObjects"
    public static let findSimilarObjects2Method = "axxonsoft.bl.events.EventHistoryService.FindSimilarObjects2"
    public static let findByPromptMethod = "axxonsoft.bl.events.EventHistoryService.FindByPrompt"

    // MARK: - ReadEvents

    /// Endpoint: `POST /grpc` → `EventHistoryService.ReadEvents`
    ///
    /// Response is SSE (`text/event-stream`) with JSON `ReadEventsPage` payloads.
    ///
    /// For fan-out queries, avoid `limit`/`offset`; merge pages client-side instead.
    public static func readEvents(_ body: ReadEventsRequest) -> Request<PagedResponse<ReadEventsPage>> {
        grpc(method: readEventsMethod, data: body)
    }

    /// ReadEvents for the last hour with optional event-type filters.
    public static func readEventsLastHour(
        filters: SearchFilterArray = SearchFilterArray(filters: []),
        limit: Int? = 100,
        offset: Int? = 0
    ) -> Request<PagedResponse<ReadEventsPage>> {
        let end = Date()
        let begin = end.addingTimeInterval(-3600)
        return readEvents(
            ReadEventsRequest(
                range: TimeRange(begin: begin, end: end),
                filters: filters,
                limit: limit,
                offset: offset
            )
        )
    }

    // MARK: - ReadAlerts

    /// Endpoint: `POST /grpc` → `EventHistoryService.ReadAlerts`
    public static func readAlerts(_ body: ReadAlertsRequest) -> Request<PagedResponse<ReadAlertsPage>> {
        grpc(method: readAlertsMethod, data: body)
    }

    // MARK: - ReadLprEvents

    /// Endpoint: `POST /grpc` → `EventHistoryService.ReadLprEvents`
    public static func readLprEvents(_ body: ReadLprEventsRequest) -> Request<PagedResponse<ReadLprEventsPage>> {
        grpc(method: readLprEventsMethod, data: body)
    }

    // MARK: - FindSimilarObjects

    /// Endpoint: `POST /grpc` → `EventHistoryService.FindSimilarObjects`
    ///
    /// Used by axxonnext.webclient for face/object image search.
    public static func findSimilarObjects(
        _ body: FindSimilarObjectsRequest
    ) -> Request<PagedResponse<FindSimilarObjectsPage>> {
        grpc(method: findSimilarObjectsMethod, data: body)
    }

    /// Endpoint: `POST /grpc` → `EventHistoryService.FindSimilarObjects2`
    ///
    /// Proto documents filter support for this variant; verify on target server via integration tests.
    public static func findSimilarObjects2(
        _ body: FindSimilarObjectsRequest
    ) -> Request<PagedResponse<FindSimilarObjectsPage>> {
        grpc(method: findSimilarObjects2Method, data: body)
    }

    // MARK: - FindByPrompt

    /// Endpoint: `POST /grpc` → `EventHistoryService.FindByPrompt`
    public static func findByPrompt(_ body: FindByPromptRequest) -> Request<PagedResponse<FindByPromptPage>> {
        grpc(method: findByPromptMethod, data: body)
    }

    // MARK: - Private

    private static func grpc<Body: Encodable & Sendable, Page: Decodable & Sendable>(
        method: String,
        data: Body
    ) -> Request<PagedResponse<Page>> {
        Request(
            path: "/grpc",
            method: .post,
            body: GrpcEnvelope(method: method, data: data)
        )
    }
}
