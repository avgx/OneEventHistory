import Foundation

/// Calendar day clipped to the journal interval. `nil` when the day does not overlap it.
public enum EventHistoryDay {
    public static func interval(
        containing day: Date,
        within globalInterval: DateInterval,
        calendar: Calendar = .current
    ) -> DateInterval? {
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        let start = max(startOfDay, globalInterval.start)
        let end = min(endOfDay, globalInterval.end)
        guard start < end else { return nil }
        return DateInterval(start: start, end: end)
    }

    static func timeRange(
        containing day: Date,
        within globalInterval: DateInterval,
        calendar: Calendar
    ) -> TimeRange? {
        guard let interval = interval(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return TimeRange(begin: interval.start, end: interval.end)
    }
}

public extension ReadEventsRequest {
    static func forDay(
        _ day: Date,
        within globalInterval: DateInterval,
        filters: SearchFilterArray,
        descending: Bool = true,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> ReadEventsRequest? {
        guard let range = EventHistoryDay.timeRange(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return ReadEventsRequest(
            range: range,
            filters: filters,
            limit: limit,
            offset: offset,
            descending: descending
        )
    }
}

public extension ReadBookmarksRequest {
    static func forDay(
        _ day: Date,
        within globalInterval: DateInterval,
        filter: BookmarkSearchFilter,
        descending: Bool = true,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> ReadBookmarksRequest? {
        guard let range = EventHistoryDay.timeRange(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return ReadBookmarksRequest(
            range: range,
            filter: filter,
            limit: limit,
            offset: offset,
            descending: descending
        )
    }
}

public extension ReadTextEventsRequest {
    static func forDay(
        _ day: Date,
        within globalInterval: DateInterval,
        filters: SearchTextFilterArray,
        descending: Bool = true,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> ReadTextEventsRequest? {
        guard let range = EventHistoryDay.timeRange(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return ReadTextEventsRequest(
            range: range,
            filters: filters,
            limit: limit,
            offset: offset,
            descending: descending
        )
    }
}

public extension FindSimilarObjectsRequest {
    static func forDay(
        _ day: Date,
        within globalInterval: DateInterval,
        originIds: [String],
        minimalScore: Double,
        jpegBase64: String,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> FindSimilarObjectsRequest? {
        guard let range = EventHistoryDay.timeRange(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return FindSimilarObjectsRequest(
            isFace: true,
            range: range,
            minimalScore: minimalScore,
            originIds: originIds,
            query: .jpegBase64(jpegBase64),
            limit: limit,
            offset: offset
        )
    }
}

public extension ReadLprEventsRequest {
    static func forDay(
        _ day: Date,
        within globalInterval: DateInterval,
        filters: LprSearchFilterArray? = nil,
        searchPredicate: String? = nil,
        descending: Bool = true,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> ReadLprEventsRequest? {
        guard let range = EventHistoryDay.timeRange(containing: day, within: globalInterval, calendar: calendar) else {
            return nil
        }
        return ReadLprEventsRequest(
            range: range,
            filters: filters,
            searchPredicate: searchPredicate,
            limit: limit,
            offset: offset,
            descending: descending
        )
    }
}
