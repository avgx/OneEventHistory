import Foundation
import Testing
@testable import OneEventHistory

@Suite("Recognized plate")
struct RecognizedPlateTests {
    @Test("PlateType ordinal 36 is a private vehicle and 35 is a private motorcycle")
    func plateTypeOrdinals() {
        #expect(PlateType(rawValue: 35) == .privateMotorcycle)
        #expect(PlateType(rawValue: 36) == .privateVehicle)
    }

    @Test("data hypotheses use corner arrays even when width and height would fit the frame")
    func hypothesesCorners() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h1",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{}],
              "data": {
                "Hypotheses": [{
                  "PlateFull": "A100AA10",
                  "PlateCountry": "ee",
                  "OCRQuality": 90,
                  "PlateColorStr": "",
                  "PlateState": "",
                  "PlateRectangle": [0.25, 0.25, 0.5, 0.5]
                }]
              }
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "A100AA10")
        #expect(plate.country == "ee")
        #expect(plate.color == nil)
        #expect(plate.rectangle?.minX == 0.25)
        #expect(plate.rectangle?.minY == 0.25)
        #expect(plate.rectangle?.width == 0.25)
        #expect(plate.rectangle?.height == 0.25)
    }

    @Test("stripped details still read the plate from data hypotheses")
    func strippedDetails() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h2",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{"object_id": 7}, {}, {}],
              "data": {
                "PlateType": 36,
                "Hypotheses": [{
                  "PlateFull": "B200BB20",
                  "PlateCountry": "ru",
                  "OCRQuality": 80,
                  "PlateRectangle": [0.25, 0.5, 0.375, 0.5625]
                }]
              }
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "B200BB20")
        #expect(plate.country == "ru")
        #expect(plate.plateType == .privateVehicle)
        #expect(plate.rectangle?.width == 0.125)
        #expect(plate.rectangle?.height == 0.0625)
    }

    @Test("full recognition keeps one row per attribute and hides empty vehicle fields")
    func fullRecognition() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h3",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [
                {"object_id": 1},
                {
                  "auto_recognition_result_ex": {
                    "direction": {"value": "Incoming"},
                    "plate_type": {"value": "EPrivateVehicle"},
                    "vehicle_class": {"value": "Car"},
                    "hypotheses": [{
                      "ocr_quality": 70,
                      "plate_full": "C300CC30",
                      "country": "Russia",
                      "plate_rectangle": {"x": 0.25, "y": 0.5, "w": 0.125, "h": 0.0625, "index": 0}
                    }]
                  }
                },
                {
                  "auto_recognition_result": {
                    "direction": "Incoming",
                    "plate_type": "EPrivateVehicle",
                    "vehicle_class": "Car",
                    "vehicle_color": "Gray",
                    "vehicle_brand": "Nissan",
                    "vehicle_model": "X Trail",
                    "headlights_status": "Undefined",
                    "vehicle_speed": 0,
                    "vehicle_subclass": "VehicleSubclassUnknown",
                    "hypotheses": [{
                      "ocr_quality": 99,
                      "plate_full": "C300CC30",
                      "country": "Russia",
                      "plate_rectangle": {"x": 0.25, "y": 0.5, "w": 0.125, "h": 0.0625, "index": 0}
                    }]
                  }
                }
              ],
              "data": {
                "PlateType": 36,
                "Direction": 1,
                "VehicleClass": 1,
                "VehicleColor": "Gray",
                "VehicleBrand": "Nissan",
                "VehicleModel": "X Trail",
                "Hypotheses": [{
                  "PlateFull": "C300CC30",
                  "PlateCountry": "Russia",
                  "OCRQuality": 99,
                  "PlateRectangle": [0.25, 0.5, 0.375, 0.5625]
                }]
              }
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "C300CC30")
        #expect(plate.country == "Russia")
        #expect(plate.plateType == .privateVehicle)
        #expect(plate.vehicleClass == .car)
        #expect(plate.color == "Gray")
        #expect(plate.brand == "Nissan")
        #expect(plate.model == "X Trail")
        #expect(plate.headlights == nil)
        #expect(plate.direction == .incoming)
        #expect(plate.rectangle?.width == 0.125)
    }

    @Test("details-only recognition drops unknown class and empty brand")
    func detailsOnly() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h4",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{
                "auto_recognition_result": {
                  "plate_type": "EPrivateMotorcycle",
                  "vehicle_class": "VehicleClassUnknown",
                  "vehicle_brand": "",
                  "vehicle_color": "",
                  "headlights_status": "Undefined",
                  "hypotheses": [{
                    "ocr_quality": 60,
                    "plate_full": "D400DD40",
                    "country": "ru",
                    "plate_rectangle": {"x": 0.1, "y": 0.2, "w": 0.3, "h": 0.4, "index": 0}
                  }]
                }
              }]
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "D400DD40")
        #expect(plate.country == "ru")
        #expect(plate.plateType == .privateMotorcycle)
        #expect(plate.vehicleClass == nil)
        #expect(plate.brand == nil)
        #expect(plate.color == nil)
        #expect(plate.headlights == nil)
        #expect(plate.rectangle?.minX == 0.1)
        #expect(plate.rectangle?.width == 0.3)
    }

    @Test("several hypotheses keep the highest score and read direction 1 as incoming")
    func bestHypothesis() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h5",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{
                "auto_recognition_result": {
                  "direction": 1,
                  "hypotheses": [
                    {
                      "ocr_quality": 81,
                      "plate_full": "E500EE50",
                      "country": "ru",
                      "plate_rectangle": {"x": 0.4, "y": 0.4, "w": 0.1, "h": 0.1, "index": 0}
                    },
                    {"ocr_quality": 39, "plate_full": "E500EE51", "country": "ru"},
                    {"ocr_quality": 51, "plate_full": "E500EE52", "country": "ru"}
                  ]
                }
              }]
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "E500EE50")
        #expect(plate.country == "ru")
        #expect(plate.direction == .incoming)
        #expect(plate.plateType == nil)
        #expect(plate.rectangle?.width == 0.1)
    }

    @Test("a starred alternate loses to the higher score")
    func starredAlternate() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h6",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{
                "auto_recognition_result": {
                  "direction": 1,
                  "hypotheses": [
                    {"ocr_quality": 74, "plate_full": "F600FF60", "country": "ru",
                     "plate_rectangle": {"x": 0.2, "y": 0.2, "w": 0.2, "h": 0.05, "index": 0}},
                    {"ocr_quality": 72, "plate_full": "F600FF60*", "country": "ru"},
                    {"ocr_quality": 33, "plate_full": "G700GG70", "country": "ru"}
                  ]
                }
              }]
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "F600FF60")
        #expect(plate.direction == .incoming)
    }

    @Test("unknown direction and unknown plate type are omitted")
    func unknownValues() throws {
        let event = try decodeEvent(
            """
            {
              "guid": "h7",
              "timestamp": "20260101T000000.000000",
              "event_type": "plateRecognized",
              "details": [{
                "auto_recognition_result": {
                  "direction": "Unknown",
                  "plate_type": "EUnknownPlateType",
                  "hypotheses": [{
                    "ocr_quality": 10,
                    "plate_full": "H800HH80",
                    "country": "ru"
                  }]
                }
              }],
              "data": {"PlateType": 36, "Direction": 0}
            }
            """
        )
        let plate = try #require(event.recognizedPlate)
        #expect(plate.number == "H800HH80")
        #expect(plate.direction == nil)
        #expect(plate.plateType == nil)
    }

    private func decodeEvent(_ body: String) throws -> Event {
        let json = """
        {"event_type":"ET_DetectorEvent","event_name":"DetectorEvent","body":\(body)}
        """
        return try JSONDecoder().decode(Event.self, from: Data(json.utf8))
    }
}
