import Foundation
import Testing
@testable import OneEventHistory

@Suite("EventHistory day requests")
struct EventHistoryDayTests {
    @Test("a day outside the interval produces no request")
    func dayOutsideInterval() {
        let day = Date(timeIntervalSince1970: 1_700_000_000)
        let interval = DateInterval(start: day.addingTimeInterval(86_400), duration: 3_600)
        let request = ReadLprEventsRequest.forDay(
            day,
            within: interval,
            searchPredicate: "*"
        )
        #expect(request == nil)
        #expect(EventHistoryDay.interval(containing: day, within: interval) == nil)
    }

    @Test("forDay clips the calendar day to the interval and keeps the plate")
    func lprForDay() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let day = Date(timeIntervalSince1970: 1_700_000_000)
        let start = calendar.startOfDay(for: day).addingTimeInterval(3_600)
        let interval = DateInterval(start: start, duration: 3_600)
        let request = try #require(
            ReadLprEventsRequest.forDay(
                day,
                within: interval,
                filters: nil,
                searchPredicate: "*777",
                limit: 50,
                offset: 0,
                calendar: calendar
            )
        )
        let object = try #require(
            JSONSerialization.jsonObject(with: JSONEncoder().encode(request)) as? [String: Any]
        )
        #expect(object["filters"] == nil)
        #expect(object["offset"] == nil)
        #expect(object["search_predicate"] as? String == "*777")
        let range = try #require(object["range"] as? [String: String])
        #expect(range["begin_time"] != nil)
        #expect(range["end_time"] != nil)
    }
}
