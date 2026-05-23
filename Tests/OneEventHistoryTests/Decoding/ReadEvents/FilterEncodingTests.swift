import Foundation
import Testing
@testable import OneEventHistory

@Suite("SearchFilter encoding")
struct FilterEncodingTests {
    @Test("detectorEvent filter matches webclient shape")
    func detectorEventFilter() throws {
        let filter = SearchFilter.detectorEvent(
            origin: "hosts/Node1/Cameras.1",
            eventValues: [.faceAppeared]
        )
        #expect(filter.type == .detectorEvent)
        #expect(filter.subjects == ["hosts/Node1/Cameras.1"])
        #expect(filter.values == ["faceAppeared"])

        let data = try JSONEncoder().encode(filter)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("ET_DetectorEvent"))
        #expect(json.contains("faceAppeared"))
    }

    @Test("SearchFilter type is EEventType enum")
    func typedInit() throws {
        let filter = SearchFilter(
            type: .bookmark,
            subjects: ["hosts/Node1/Cameras.1"],
            values: ["guid-1"]
        )
        #expect(filter.type == .bookmark)

        let data = try JSONEncoder().encode(filter)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json.contains("ET_Bookmark"))
    }
}
