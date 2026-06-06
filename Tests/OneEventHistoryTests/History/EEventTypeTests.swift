import Foundation
import Testing
@testable import OneEventHistory

@Suite("EEventType")
struct EEventTypeTests {
    @Test("EEventType encodes proto raw values")
    func eeventTypeEncoding() throws {
        let data = try JSONEncoder().encode(EEventType.macroEvent)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json == "\"ET_MacroEvent\"")
    }
}
