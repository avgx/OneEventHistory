import Foundation

public struct HistoryCustomPeriod: Equatable, Sendable {
    public var startDate: Date?
    public var endDate: Date?

    public init(startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }

    public var isEmpty: Bool {
        startDate == nil && endDate == nil
    }

    public func resolvedInterval(calendar: Calendar = .current, now: Date = .now) -> DateInterval {
        let start = startDate ?? .distantPast
        let end = endDate ?? now
        return DateInterval(start: min(start, end), end: max(start, end))
    }
}

public enum HistoryTimeFilter: Equatable, Sendable {
    case today
    case days(selectedDay: Date)
    case custom(HistoryCustomPeriod)

    public var isDefault: Bool {
        if case .today = self { return true }
        return false
    }

    public func resolvedInterval(calendar: Calendar = .current, now: Date = .now) -> DateInterval {
        switch self {
        case .today:
            let start = calendar.startOfDay(for: now)
            return DateInterval(start: start, end: now)
        case .days(let selectedDay):
            let start = calendar.startOfDay(for: selectedDay)
            let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
            return DateInterval(start: start, end: end)
        case .custom(let period):
            return period.resolvedInterval(calendar: calendar, now: now)
        }
    }

    public func dayStripDays(calendar: Calendar = .current, now: Date = .now) -> [Date] {
        let today = calendar.startOfDay(for: now)
        return (0..<31).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today).map { calendar.startOfDay(for: $0) }
        }.reversed()
    }

    public func upperBoundIsNow(calendar: Calendar = .current, now: Date = .now) -> Bool {
        switch self {
        case .today:
            return true
        case .days(let selectedDay):
            return calendar.isDate(selectedDay, inSameDayAs: now)
        case .custom(let period):
            guard let endDate = period.endDate else { return true }
            let startOfToday = calendar.startOfDay(for: now)
            return endDate >= startOfToday
        }
    }

    public func anchorDay(calendar: Calendar = .current, now: Date = .now) -> Date {
        switch self {
        case .today:
            return calendar.startOfDay(for: now)
        case .days(let selectedDay):
            return calendar.startOfDay(for: selectedDay)
        case .custom(let period):
            let interval = period.resolvedInterval(calendar: calendar, now: now)
            return calendar.startOfDay(for: interval.end)
        }
    }

    public static func yesterday(calendar: Calendar = .current, now: Date = .now) -> Date {
        let today = calendar.startOfDay(for: now)
        return calendar.date(byAdding: .day, value: -1, to: today) ?? today
    }
}
