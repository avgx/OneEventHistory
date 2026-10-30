import Foundation
import JSONValue
import SafeEnum

/// Reads an `Int` enum from wire JSON.
///
/// A value may be the case name (`Incoming`), a wrapped name (`{"value":"Incoming"}`),
/// the ordinal (`1`), or a wrapped ordinal (`{"value":1}`). Case names match `String(describing:)`.
enum WireEnum {
    static func enumValue<T: RawRepresentable & CaseIterable>(
        _ type: T.Type,
        from value: JSONValue?
    ) -> T? where T.RawValue == Int {
        if let name = unwrappedString(value), let parsed = named(type, name) {
            return parsed
        }
        let number = value?.intValue ?? value?["value"]?.intValue
        if let number, let parsed = T(rawValue: number) {
            return parsed
        }
        return nil
    }

    /// First parsed value that is not `hidden`. Each source is a JSON object, then its `data` fallback.
    static func first<T: RawRepresentable & CaseIterable & Equatable>(
        _ type: T.Type,
        in sources: [(result: JSONValue?, data: SafeEnum<T>?)],
        keys: [String],
        hiding hidden: T
    ) -> T? where T.RawValue == Int {
        for source in sources {
            if let result = source.result {
                for key in keys {
                    if let value = enumValue(type, from: result[key]), value != hidden {
                        return value
                    }
                }
            }
            if let value = source.data?.value, value != hidden {
                return value
            }
        }
        return nil
    }

    private static func named<T: RawRepresentable & CaseIterable>(
        _ type: T.Type,
        _ name: String
    ) -> T? where T.RawValue == Int {
        let folded = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return type.allCases.first { String(describing: $0).lowercased() == folded }
    }

    private static func unwrappedString(_ value: JSONValue?) -> String? {
        guard let value else { return nil }
        if let string = value.stringValue {
            return string
        }
        return value["value"]?.stringValue
    }
}
