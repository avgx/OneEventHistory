import Foundation
import JSONValue
import Testing
@testable import OneEventHistory

@Suite("Listed item bindings")
struct ListedItemBindingTests {
    @Test("lists_info is the binding, and a lone list_id still decodes")
    func listsInfo() throws {
        let json = """
        {
          "listed_item_detected_result": {
            "lists_info": [{"list_id": "list-1", "list_name": "Guests"}],
            "list_id": "old",
            "list_name": "Old"
          }
        }
        """
        let details = try JSONDecoder().decode(Details.self, from: Data(json.utf8))
        #expect(details.listedItemBindings == [ListedItemBinding(listID: "list-1", listName: "Guests")])
    }

    @Test("deprecated list_id is used when lists_info is absent")
    func deprecatedListID() throws {
        let json = """
        {"listed_item_detected_result": {"list_id": "list-9", "list_name": "Staff"}}
        """
        let details = try JSONDecoder().decode(Details.self, from: Data(json.utf8))
        #expect(details.listedItemBindings.map(\.listID) == ["list-9"])
        #expect(details.listedItemBindings.map(\.listName) == ["Staff"])
    }

    @Test("an event without the structured result has no list")
    func missing() throws {
        let details = try JSONDecoder().decode(Details.self, from: Data("{}".utf8))
        #expect(details.listedItemBindings.isEmpty)
    }
}
