import Foundation

public enum DayRange {
    public static func calendarDay(containing date: Date, calendar: Calendar = .current) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        return DateInterval(start: start, end: end)
    }

    public static func days(in interval: DateInterval, calendar: Calendar = .current) -> [Date] {
        var result: [Date] = []
        var day = calendar.startOfDay(for: interval.start)
        let last = calendar.startOfDay(for: interval.end)
        while day <= last {
            result.append(day)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return result
    }

    public static func clamp(_ day: Date, to interval: DateInterval, calendar: Calendar = .current) -> DateInterval? {
        let dayInterval = calendarDay(containing: day, calendar: calendar)
        let start = max(dayInterval.start, interval.start)
        let end = min(dayInterval.end, interval.end)
        guard start < end else { return nil }
        return DateInterval(start: start, end: end)
    }
}

public struct HourSection: Equatable, Sendable {
    public let hour: Date
    public let events: [Event]
}

public extension Array where Element == Event {
    func filtered(query: EventHistoryQuery, plan: ExecutionPlan) -> [Event] {
        filter { event in
            if !query.eventTypes.isEmpty,
               !query.eventTypes.contains(event.body.eventType ?? "") {
                return false
            }
            let constraints = plan.clientConstraints
            if !constraints.cameras.isEmpty {
                guard let origin = event.body.originDeprecated,
                      constraints.cameras.contains(origin) else {
                    return false
                }
            }
            if !constraints.detectors.isEmpty {
                let detectorAPs = detectorAccessPoints(for: event)
                if detectorAPs.isEmpty || Set(constraints.detectors).isDisjoint(with: detectorAPs) {
                    return false
                }
            }
            return true
        }
    }

    func groupedByHour(calendar: Calendar = .current, threshold: Int = 20) -> [HourSection] {
        guard count > threshold else {
            return [HourSection(hour: .distantPast, events: self)]
        }
        var sections: [Date: [Event]] = [:]
        for event in self {
            guard let timestamp = event.body.timestampDate else { continue }
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: timestamp)
            let hour = calendar.date(from: components) ?? timestamp
            sections[hour, default: []].append(event)
        }
        return sections.keys.sorted(by: >).map { hour in
            HourSection(hour: hour, events: sections[hour] ?? [])
        }
    }

    private func detectorAccessPoints(for event: Event) -> Set<String> {
        var values: Set<String> = []
        if let origin = event.body.originDeprecated, !origin.isEmpty {
            values.insert(origin)
        }
        if let originID = event.body.data?.originId, !originID.isEmpty {
            values.insert(originID)
        }
        if let group = event.body.detectorsGroup {
            values.formUnion(group)
        }
        return values
    }
}

public extension ReadEventsRequest {
    static func forDay(
        _ day: Date,
        globalInterval: DateInterval,
        query: EventHistoryQuery,
        plan: ExecutionPlan,
        descending: Bool = true,
        limit: Int = 50,
        offset: Int = 0,
        calendar: Calendar = .current
    ) -> ReadEventsRequest? {
        guard let dayInterval = DayRange.clamp(day, to: globalInterval, calendar: calendar) else {
            return nil
        }
        return ReadEventsRequest(
            range: TimeRange(begin: dayInterval.start, end: dayInterval.end),
            filters: plan.serverFilters,
            limit: limit,
            offset: offset,
            descending: descending
        )
    }
}
