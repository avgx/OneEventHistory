import Foundation
import RequestResponse
import Testing
@testable import OneEventHistory

@Suite("EventHistoryApi request builders")
struct EventHistoryApiTests {
    @Test("readEvents builds POST /grpc envelope")
    func readEventsRequest() throws {
        let body = ReadEventsRequest(
            range: TimeRange(
                begin: Date(timeIntervalSince1970: 1_700_000_000),
                end: Date(timeIntervalSince1970: 1_700_003_600)
            ),
            filters: SearchFilterArray(filters: [
                .faceAppeared(on: "hosts/Demo/Cameras.1"),
            ]),
            limit: 50,
            offset: 0
        )
        let request = EventHistoryApi.readEvents(body)
        #expect(request.path == "/grpc")
        #expect(request.method == .post)
    }

    @Test("typed Request response markers")
    func typed_request_markers() {
        let range = TimeRange(begin: .distantPast, end: .distantFuture)
        let _: Request<PagedResponse<ReadEventsPage>> = EventHistoryApi.readEvents(
            ReadEventsRequest(range: range, filters: SearchFilterArray(filters: []))
        )
        let _: Request<PagedResponse<ReadAlertsPage>> = EventHistoryApi.readAlerts(
            ReadAlertsRequest(
                range: range,
                filters: AlertsSearchFilterArray(filters: [])
            )
        )
        let _: Request<PagedResponse<ReadLprEventsPage>> = EventHistoryApi.readLprEvents(
            ReadLprEventsRequest(
                range: range,
                filters: LprSearchFilterArray(filters: [])
            )
        )
        let similar = FindSimilarObjectsRequest(
            isFace: true,
            range: range,
            minimalScore: 0.5,
            originIds: ["hosts/X"],
            query: .jpegBase64("AAA")
        )
        let _: Request<PagedResponse<FindSimilarObjectsPage>> = EventHistoryApi.findSimilarObjects(similar)
        let _: Request<PagedResponse<FindSimilarObjectsPage>> = EventHistoryApi.findSimilarObjects2(similar)
        let _: Request<PagedResponse<FindByPromptPage>> = EventHistoryApi.findByPrompt(
            FindByPromptRequest(
                prompt: "person with backpack",
                range: range,
                minimalScore: 0.5,
                originIds: ["hosts/X"]
            )
        )
    }
}
