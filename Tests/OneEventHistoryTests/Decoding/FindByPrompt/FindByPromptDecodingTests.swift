import Foundation
import Testing
@testable import OneEventHistory

@Suite("FindByPrompt decoding")
struct FindByPromptDecodingTests {
    @Test("decode FindByPromptPage synthetic JSON")
    func decodePage() throws {
        let json = """
        {
          "items": [],
          "error": { "message": "Not implemented" }
        }
        """
        let page = try JSONDecoder().decode(FindByPromptPage.self, from: Data(json.utf8))
        #expect(page.items.isEmpty)
        #expect(page.error?.message == "Not implemented")
    }

    @Test("encode FindByPromptRequest")
    func encodeRequest() throws {
        let request = FindByPromptRequest(
            prompt: "red car",
            range: TimeRange(begin: .distantPast, end: .distantFuture),
            minimalScore: 0.4,
            originIds: ["hosts/X"],
            filters: FieldsFilterArray(filters: [
                FieldFilter(fullPathToField: "details.color", valueString: "red"),
            ])
        )
        let data = try JSONEncoder().encode(request)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("red car"))
        #expect(json.contains("full_path_to_field"))
    }
}
