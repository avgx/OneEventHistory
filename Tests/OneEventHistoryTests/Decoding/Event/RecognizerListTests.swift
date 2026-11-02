import Foundation
import Presentable
import Testing
@testable import OneEventHistory

@Suite("Recognizer lists")
struct RecognizerListTests {
    @Test("GetListStream falls back only when the method is missing")
    func fallback() {
        let missing = RecognizerCallError.from(grpcCode: 12)
        #expect(missing == .unimplemented)
        #expect(missing.shouldFallbackToGetLists)

        let denied = RecognizerCallError.from(grpcCode: 7)
        #expect(denied == .permissionDenied)
        #expect(!denied.shouldFallbackToGetLists)

        let unavailable = RecognizerCallError.from(grpcCode: 14)
        #expect(unavailable == .unavailable)
        #expect(!unavailable.shouldFallbackToGetLists)
    }

    @Test("stream pages keep list ids and plate strings")
    func decodeRecognizer() throws {
        let page = try JSONDecoder().decode(
            GetListStreamResponse.self,
            from: Data(#"{"status":"EPS_SEQUENTIAL","list":{"id":"list-1","name":"Guests","item_ids":["item-1"]}}"#.utf8)
        )
        #expect(page.list == NamedList(id: "list-1", name: "Guests", items: ["item-1"]))
        let last = try JSONDecoder().decode(GetListStreamResponse.self, from: Data(#"{"status":1}"#.utf8))
        #expect(last.isLast)
        let item = try JSONDecoder().decode(
            GetItemsResponse.self,
            from: Data(#"{"item":{"id":"item-1","data_string":"A100AA10"}}"#.utf8)
        )
        #expect(RecognizerListParsing.plates(from: [item]) == ["A100AA10"])
    }
}
