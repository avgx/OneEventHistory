import Foundation
import Testing
@testable import OneEventHistory

@Suite("FindSimilarObjects decoding")
struct FindSimilarObjectsDecodingTests {
    @Test("decode FindSimilarObjectsPage JSON")
    func decodePage() throws {
        let json = """
        {
          "items": [
            {
              "event": {
                "guid": "g-sim",
                "timestamp": "2026-01-01T00:00:00Z",
                "state": "ACTIVE",
                "origin_deprecated": "",
                "event_type": "face",
                "multi_phase_id": "",
                "detectors_group": ["FACE"],
                "details": [],
                "data": null
              },
              "score": 0.95
            }
          ]
        }
        """
        let page = try JSONDecoder().decode(FindSimilarObjectsPage.self, from: Data(json.utf8))
        #expect(page.items.count == 1)
        #expect(page.items[0].score == 0.95)
        #expect(page.items[0].event.guid == "g-sim")
    }

    @Test("encode FindSimilarObjectsRequest with snake_case and jpeg_image")
    func encodeRequest() throws {
        let request = FindSimilarObjectsRequest(
            isFace: true,
            range: TimeRange(
                begin: Date(timeIntervalSince1970: 1_767_225_600),
                end: Date(timeIntervalSince1970: 1_767_229_200)
            ),
            minimalScore: 0.5,
            originIds: ["hosts/X"],
            query: .jpegBase64("AAA"),
            limit: 10,
            offset: 0
        )

        let data = try JSONEncoder().encode(request)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("is_face"))
        #expect(json.contains("minimal_score"))
        #expect(json.contains("origin_ids"))
        #expect(json.contains("jpeg_image"))
        #expect(json.contains("AAA"))
    }
}
