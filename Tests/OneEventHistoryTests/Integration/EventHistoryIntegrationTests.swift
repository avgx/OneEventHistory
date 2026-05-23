import Foundation
import HTTP
import RequestResponse
import Testing
@testable import OneEventHistory

@Suite("OneEventHistory integration", .tags(.integration))
struct EventHistoryIntegrationTests {
    @Test("ReadEvents smoke against live server")
    func readEventsSmoke() async throws {
        guard EventHistoryIntegrationConfig.isIntegrationEnabled else { return }
        let credentials = try #require(EventHistoryIntegrationConfig.credentials())

        let end = Date()
        let begin = end.addingTimeInterval(-7 * 24 * 3600)
        let body = ReadEventsRequest(
            range: TimeRange(begin: begin, end: end),
            filters: SearchFilterArray(filters: [
                SearchFilter(type: .detectorEvent, values: [DetectorEventValue.faceAppeared.rawValue]),
            ]),
            limit: 50,
            offset: 0
        )

        let pages = try await performPages(
            EventHistoryApi.readEvents(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )
        _ = pages.flatMap(\.items)
    }

    @Test("FindSimilarObjects vs FindSimilarObjects2 A/B")
    func findSimilarObjectsAB() async throws {
        guard EventHistoryIntegrationConfig.isIntegrationEnabled else { return }
        let credentials = try #require(EventHistoryIntegrationConfig.credentials())
        guard let jpeg = EventHistoryIntegrationConfig.testJPEGBase64 else { return }

        let end = Date()
        let begin = end.addingTimeInterval(-24 * 3600)
        let body = FindSimilarObjectsRequest(
            isFace: true,
            range: TimeRange(begin: begin, end: end),
            minimalScore: 0.5,
            originIds: [],
            query: .jpegBase64(jpeg),
            limit: 10,
            offset: 0
        )

        let v1 = try await performPages(
            EventHistoryApi.findSimilarObjects(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )
        let v2 = try await performPages(
            EventHistoryApi.findSimilarObjects2(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )

        Issue.record(
            "FindSimilarObjects A/B: v1 pages=\(v1.count) items=\(v1.flatMap(\.items).count); v2 pages=\(v2.count) items=\(v2.flatMap(\.items).count)"
        )
    }

    @Test("ReadAlerts smoke against live server")
    func readAlertsSmoke() async throws {
        guard EventHistoryIntegrationConfig.isIntegrationEnabled else { return }
        let credentials = try #require(EventHistoryIntegrationConfig.credentials())

        let end = Date()
        let begin = end.addingTimeInterval(-24 * 3600)
        let body = ReadAlertsRequest(
            range: TimeRange(begin: begin, end: end),
            filters: AlertsSearchFilterArray(filters: []),
            limit: 10
        )

        _ = try await performPages(
            EventHistoryApi.readAlerts(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )
    }

    @Test("ReadLprEvents smoke against live server")
    func readLprEventsSmoke() async throws {
        guard EventHistoryIntegrationConfig.isIntegrationEnabled else { return }
        let credentials = try #require(EventHistoryIntegrationConfig.credentials())

        let end = Date()
        let begin = end.addingTimeInterval(-24 * 3600)
        let body = ReadLprEventsRequest(
            range: TimeRange(begin: begin, end: end),
            filters: LprSearchFilterArray(filters: []),
            limit: 10
        )

        _ = try await performPages(
            EventHistoryApi.readLprEvents(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )
    }

    @Test("FindByPrompt smoke against live server")
    func findByPromptSmoke() async throws {
        guard EventHistoryIntegrationConfig.isIntegrationEnabled else { return }
        let credentials = try #require(EventHistoryIntegrationConfig.credentials())

        let end = Date()
        let begin = end.addingTimeInterval(-24 * 3600)
        let body = FindByPromptRequest(
            prompt: "person",
            range: TimeRange(begin: begin, end: end),
            minimalScore: 0.3,
            originIds: []
        )

        _ = try await performPages(
            EventHistoryApi.findByPrompt(body),
            baseURL: credentials.baseURL,
            user: credentials.user,
            password: credentials.password
        )
    }

    // MARK: - Private

    private func performPages<Page: Decodable & Sendable>(
        _ request: Request<PagedResponse<Page>>,
        baseURL: URL,
        user: String,
        password: String
    ) async throws -> [Page] {
        let auth = Data("\(user):\(password)".utf8).base64EncodedString()
        var grpcRequest = request
        grpcRequest.headers = [
            "Authorization": "Basic \(auth)",
            "Accept": "text/event-stream",
            "User-Agent": "OneEventHistoryTests/1.0",
        ]

        let builder = RequestBuilder.json(baseURL: baseURL, encoder: JSONEncoder())
        let client = HTTPClient()
        return try await client.pages(grpcRequest, with: builder)
    }
}

extension Tag {
    @Tag static var integration: Self
}
