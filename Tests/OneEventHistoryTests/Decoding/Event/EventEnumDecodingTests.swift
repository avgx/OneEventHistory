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
        #expect(body.state?.value == .active)
    }

    @Test("EventBody decodes without state")
    func eventBodyWithoutState() throws {
        let json = """
        {
          "guid": "g1",
          "timestamp": "2026-01-01T00:00:00Z",
          "origin_deprecated": "",
          "event_type": "face",
          "multi_phase_id": "",
          "detectors_group": [],
          "details": []
        }
        """
        let body = try JSONDecoder().decode(EventBody.self, from: Data(json.utf8))
        #expect(body.state == nil)
    }

    @Test("EventData decodes without FaceId")
    func eventDataWithoutFaceId() throws {
        let json = """
        {
          "DetectorsGroup": ["MOTION"],
          "ObjectId": 1,
          "detector_type": "motion",
          "origin_id": "hosts/H/Device/Source",
          "phase": 0,
          "rectangles": [[1, 2, 3, 4]]
        }
        """
        let data = try JSONDecoder().decode(EventData.self, from: Data(json.utf8))
        #expect(data.faceId == nil)
        #expect(data.objectId == 1)
    }

    @Test("EventBody decodes MacroEvent shape without detector fields")
    func eventBodyMacroEventShape() throws {
        let json = """
        {
          "guid": "98c37a05-a180-43e6-8d0a-22bf3fd68b1a",
          "timestamp": "20260605T195600.590991",
          "node_info": {"name": "AVGXNUC", "friendly_name": "AVGXNUC"},
          "camera": {"access_point": "hosts/AVGXNUC/DeviceIpint.66/SourceEndpoint.video:0:0"},
          "macro": {"guid": "f5ed49c7-2722-0742-8dc1-87ac80735d15"},
          "initiator_type": "MIT_DETECTOR_EVENT",
          "action_type": "RAT_WRITE_ARCHIVE",
          "phase": "AEP_COMPLETED"
        }
        """
        let body = try JSONDecoder().decode(EventBody.self, from: Data(json.utf8))
        #expect(body.originDeprecated == nil)
        #expect(body.details == nil)
    }

    @Test("Details decodes with rectangle only")
    func detailsRectangleOnly() throws {
        let json = """
        {"rectangle": {"x": 1, "y": 2, "w": 3, "h": 4, "index": 0}}
        """
        let details = try JSONDecoder().decode(Details.self, from: Data(json.utf8))
        #expect(details.objectId == nil)
        #expect(details.rectangle != nil)
    }

    @Test("Event decodes MacroEvent without required_permissions")
    func macroEventWithoutRequiredPermissions() throws {
        let json = """
        {
          "event_type": "ET_MacroEvent",
          "subject": "",
          "event_name": "axxonsoft.bl.events.MacroEvent",
          "body": {
            "guid": "98c37a05-a180-43e6-8d0a-22bf3fd68b1a",
            "timestamp": "20260605T195600.590991",
            "node_info": {"name": "AVGXNUC", "friendly_name": "AVGXNUC"},
            "camera": {"access_point": "hosts/AVGXNUC/DeviceIpint.66/SourceEndpoint.video:0:0"},
            "macro": {"guid": "f5ed49c7-2722-0742-8dc1-87ac80735d15"},
            "initiator_type": "MIT_DETECTOR_EVENT",
            "action_type": "RAT_WRITE_ARCHIVE",
            "phase": "AEP_COMPLETED"
          },
          "subjects": ["AVGXNUC"],
          "external": false,
          "localization": {"text": "Macro"}
        }
        """
        let event = try JSONDecoder().decode(Event.self, from: Data(json.utf8))
        #expect(event.requiredPermissions == nil)
        #expect(event.body.originDeprecated == nil)
    }

    @Test("Event resolves camera friendly name from origin_ext")
    func cameraFriendlyNameFromOriginExt() throws {
        let json = """
        {
          "event_type": "ET_DetectorEvent",
          "subject": "",
          "event_name": "axxonsoft.bl.events.DetectorEvent",
          "body": {
            "guid": "g1",
            "timestamp": "20260605T195547.101000",
            "origin_deprecated": "hosts/AVGXNUC/DeviceIpint.65/SourceEndpoint.video:0:0",
            "origin_ext": {
              "access_point": "hosts/AVGXNUC/DeviceIpint.65/SourceEndpoint.video:0:0",
              "friendly_name": "66.vertical",
              "group": ""
            }
          },
          "subjects": [],
          "external": false,
          "localization": {"text": "Detector"}
        }
        """
        let event = try JSONDecoder().decode(Event.self, from: Data(json.utf8))
        #expect(event.cameraFriendlyName == "66.vertical")
        #expect(event.cameraAccessPoint == "hosts/AVGXNUC/DeviceIpint.65/SourceEndpoint.video:0:0")
    }
}
