import Foundation
import JSONValue
import SafeEnum
import Testing
@testable import OneEventHistory

@Suite("Wire enum")
struct WireEnumTests {
    @Test("a case name, a wrapped name, an ordinal, and a wrapped ordinal all decode")
    func enumValueForms() {
        #expect(WireEnum.enumValue(Sample.self, from: .string("incoming")) == .incoming)
        #expect(WireEnum.enumValue(Sample.self, from: .object(["value": .string("Outgoing")])) == .outgoing)
        #expect(WireEnum.enumValue(Sample.self, from: .integer(1)) == .incoming)
        #expect(WireEnum.enumValue(Sample.self, from: .object(["value": .integer(2)])) == .outgoing)
        #expect(WireEnum.enumValue(Sample.self, from: .string("  Incoming  ")) == .incoming)
    }

    @Test("an unknown name, an unknown ordinal, and a missing value stay nil")
    func enumValueRejectsUnknown() {
        #expect(WireEnum.enumValue(Sample.self, from: .string("VehicleClassUnknown")) == nil)
        #expect(WireEnum.enumValue(Sample.self, from: .string("1")) == nil)
        #expect(WireEnum.enumValue(Sample.self, from: .integer(99)) == nil)
        #expect(WireEnum.enumValue(Sample.self, from: nil) == nil)
        #expect(WireEnum.enumValue(Sample.self, from: .null) == nil)
    }

    @Test("the first shown value wins and a hidden value falls through")
    func firstSkipsHidden() {
        let hiddenThenIncoming = WireEnum.first(
            Sample.self,
            in: [
                (result: .object(["direction": .string("Unknown")]), data: nil),
                (result: .object(["Direction": .integer(1)]), data: SafeEnum(.outgoing)),
            ],
            keys: ["direction", "Direction"],
            hiding: .unknown
        )
        #expect(hiddenThenIncoming == .incoming)

        let missingThenData = WireEnum.first(
            Sample.self,
            in: [
                (result: .object([:]), data: SafeEnum(.outgoing)),
            ],
            keys: ["direction"],
            hiding: .unknown
        )
        #expect(missingThenData == .outgoing)

        let jsonBeforeData = WireEnum.first(
            Sample.self,
            in: [
                (result: .object(["direction": .string("Incoming")]), data: SafeEnum(.outgoing)),
            ],
            keys: ["direction"],
            hiding: .unknown
        )
        #expect(jsonBeforeData == .incoming)

        let hiddenDataFallsThrough = WireEnum.first(
            Sample.self,
            in: [
                (result: nil, data: SafeEnum(rawValue: 0)),
                (result: nil, data: SafeEnum(.incoming)),
            ],
            keys: ["direction"],
            hiding: .unknown
        )
        #expect(hiddenDataFallsThrough == .incoming)
    }
}

private enum Sample: Int, CaseIterable, Equatable, Hashable, Sendable {
    case unknown = 0
    case incoming
    case outgoing
}
