import Foundation
import Testing
@testable import OneEventHistory

@Suite("ReadLprEvents decoding")
struct ReadLprEventsDecodingTests {
    @Test("decode ReadLprEventsPage synthetic JSON")
    func decodePage() throws {
        let json = """
        {
          "items": [],
          "next_offset": 100
        }
        """
        let page = try JSONDecoder().decode(ReadLprEventsPage.self, from: Data(json.utf8))
        #expect(page.items.isEmpty)
        #expect(page.nextOffset == 100)
    }

    @Test("encode ReadLprEventsRequest")
    func encodeRequest() throws {
        let request = ReadLprEventsRequest(
            range: TimeRange(begin: .distantPast, end: .distantFuture),
            filters: LprSearchFilterArray(
                filters: [LprSearchFilter(subjects: ["hosts/X"], texts: ["ABC123"])]
            ),
            searchPredicate: "plate ~= 'ABC*'"
        )
        let data = try JSONEncoder().encode(request)
        let object = try jsonObject(data)
        let filters = try #require(object["filters"] as? [String: Any])
        let items = try #require(filters["filters"] as? [[String: Any]])
        #expect(items.first?["subjects"] as? [String] == ["hosts/X"])
        #expect(items.first?["texts"] as? [String] == ["ABC123"])
        #expect(items.first?["values"] == nil)
        #expect(object["search_predicate"] as? String == "plate ~= 'ABC*'")
    }

    @Test("encode ReadLprEventsRequest without cameras omits filters and a zero offset")
    func encodeRequestWithoutFilters() throws {
        let request = ReadLprEventsRequest(
            range: TimeRange(begin: .distantPast, end: .distantFuture),
            searchPredicate: "*",
            limit: 50,
            offset: 0,
            descending: true
        )
        let object = try jsonObject(JSONEncoder().encode(request))
        #expect(object["filters"] == nil)
        #expect(object["offset"] == nil)
        #expect(object["search_predicate"] as? String == "*")
        #expect(object["limit"] as? Int == 50)
        #expect(object["descending"] as? Bool == true)
        #expect(object["range"] != nil)
    }

    @Test("encode ReadLprEventsRequest keeps a positive offset")
    func encodeRequestOffset() throws {
        let request = ReadLprEventsRequest(
            range: TimeRange(begin: .distantPast, end: .distantFuture),
            filters: LprSearchFilterArray(filters: [
                LprSearchFilter(subjects: ["hosts/A"]),
                LprSearchFilter(subjects: ["hosts/B"]),
            ]),
            searchPredicate: "*777",
            offset: 50
        )
        let object = try jsonObject(JSONEncoder().encode(request))
        let filters = try #require(object["filters"] as? [String: Any])
        let items = try #require(filters["filters"] as? [[String: Any]])
        #expect(items.compactMap { $0["subjects"] as? [String] } == [["hosts/A"], ["hosts/B"]])
        #expect(items.allSatisfy { $0["texts"] == nil && $0["values"] == nil })
        #expect(object["search_predicate"] as? String == "*777")
        #expect(object["offset"] as? Int == 50)
    }

    private func jsonObject(_ data: Data) throws -> [String: Any] {
        try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }
}
