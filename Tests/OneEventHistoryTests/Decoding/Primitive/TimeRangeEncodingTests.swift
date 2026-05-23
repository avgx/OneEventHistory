import Foundation
import Testing
@testable import OneEventHistory

@Suite("TimeRange encoding")
struct TimeRangeEncodingTests {
    @Test("Date encodes to ASIP wire strings")
    func encodeAsip() throws {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .iso8601)
        components.timeZone = TimeZone(identifier: "UTC")
        components.year = 2026
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let begin = try #require(components.date)
        let end = begin.addingTimeInterval(3600)

        let encoded = try JSONEncoder().encode(TimeRange(begin: begin, end: end))
        let json = try #require(String(data: encoded, encoding: .utf8))
        #expect(json.contains("begin_time"))
        #expect(json.contains("20260101T000000"))
    }

    @Test("wire strings decode back to Date")
    func decodeRoundTrip() throws {
        let json = """
        {"begin_time":"20260101T000000.000000","end_time":"20260101T010000.000000"}
        """
        let range = try JSONDecoder().decode(TimeRange.self, from: Data(json.utf8))
        #expect(range.end.timeIntervalSince(range.begin) == 3600)
    }
}
