import EncodeDecode
import Foundation
import Testing
@testable import OneEventHistory

@Suite("ReadEvents decoding")
struct ReadEventsDecodingTests {
    @Test("decode ReadEventsPage JSON chunk")
    func decodeJsonChunk() throws {
        let data = try FixtureLoader.data(named: "read_events", extension: "json")
        let page = try JSONDecoder().decode(ReadEventsPage.self, from: data)

        #expect(page.items.count == 1)
        #expect(page.items.first?.eventName == "Face")
        #expect(page.items.first?.body.guid == "g1")
    }

    @Test("encode and decode Event round-trip")
    func eventCodableRoundTrip() throws {
        let data = try FixtureLoader.data(named: "events", extension: "json")
        let page = try JSONDecoder().decode(ReadEventsPage.self, from: data)
        let event = try #require(page.items.first)

        let encoded = try JSONEncoder().encode(event)
        let decoded = try JSONDecoder().decode(Event.self, from: encoded)

        #expect(decoded == event)
    }

    @Test("decode events.json fixture")
    func decodeEventsFixture() throws {
        let data = try FixtureLoader.data(named: "events", extension: "json")
        let page = try JSONDecoder().decode(ReadEventsPage.self, from: data)

        #expect(page.items.count == 1)
        #expect(page.items.first?.body.guid == "test-guid-1")
    }

    @Test("decode SSE fixture via decodeSse")
    func decodeSseFixture() throws {
        let raw = try FixtureLoader.data(named: "try_read_events", extension: "sse")
        let pages = try decodeSse(ReadEventsPage.self, from: raw, using: JSONDecoder())
        let items = pages.flatMap(\.items)

        #expect(items.isEmpty == false)
        #expect(items.first?.eventType == "face")
        #expect(items.first?.body.guid == "g1")
    }

    @Test("decode next_offset when server sends a string")
    func decodeStringNextOffset() throws {
        let json = """
        {"items":[],"next_offset":"50"}
        """.data(using: .utf8)!
        let page = try JSONDecoder().decode(ReadEventsPage.self, from: json)

        #expect(page.nextOffset == 50)
    }
}
