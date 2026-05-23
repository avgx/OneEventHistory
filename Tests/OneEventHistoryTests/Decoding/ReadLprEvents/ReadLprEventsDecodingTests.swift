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
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("search_predicate"))
        #expect(json.contains("ABC123"))
    }
}
