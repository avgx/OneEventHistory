import Foundation
import Testing
@testable import OneEventHistory

@Suite("Event enum decoding")
struct EventEnumDecodingTests {
    @Test("known Gender decodes to value")
    func knownGender() throws {
        let json = """
        {"begin_time":"2026-01-01T00:00:00Z","best_quality":0.9,"evasion_type":"NONE","age":30,"gender":"MALE"}
        """
        let result = try JSONDecoder().decode(FaceRecognitionResult.self, from: Data(json.utf8))
        #expect(result.gender.value == .male)
        #expect(result.gender.rawValue == "MALE")
    }

    @Test("unknown Gender wire value keeps rawValue with nil value")
    func unknownGender() throws {
        let json = """
        {"begin_time":"2026-01-01T00:00:00Z","best_quality":0.9,"evasion_type":"NONE","age":30,"gender":"OTHER"}
        """
        let result = try JSONDecoder().decode(FaceRecognitionResult.self, from: Data(json.utf8))
        #expect(result.gender.value == nil)
        #expect(result.gender.rawValue == "OTHER")
    }

    @Test("EventBody state uses SafeEnum")
    func eventBodyState() throws {
        let json = """
        {
          "guid": "g1",
          "timestamp": "2026-01-01T00:00:00Z",
          "state": "ACTIVE",
          "origin_deprecated": "",
          "event_type": "face",
          "multi_phase_id": "",
          "detectors_group": [],
          "details": []
        }
        """
        let body = try JSONDecoder().decode(EventBody.self, from: Data(json.utf8))
        #expect(body.state.value == .active)
    }
}
