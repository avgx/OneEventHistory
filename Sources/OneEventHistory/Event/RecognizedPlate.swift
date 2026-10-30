import Foundation
import JSONValue
import SafeEnum

/// Plate recognition extracted from a history `plateRecognized` event.
public struct RecognizedPlate: Equatable, Sendable {
    public let number: String
    public let country: String?
    public let plateType: PlateType?
    public let color: String?
    public let brand: String?
    public let model: String?
    public let vehicleClass: VehicleClass?
    public let headlights: HeadlightsStatus?
    public let direction: Direction?
    /// Normalized plate rectangle. Arrays of four numbers are corners, not width and height.
    public let rectangle: PlateRectangle?

    /// Normalized axis-aligned plate bounds.
    public struct PlateRectangle: Equatable, Sendable {
        public let minX: Double
        public let minY: Double
        public let width: Double
        public let height: Double
    }
}

extension Event {
    /// Best plate hypothesis from recognition blocks, or `data.Hypotheses` when those blocks are absent.
    public var recognizedPlate: RecognizedPlate? {
        RecognizedPlateReader.plate(from: body)
    }
}

enum RecognizedPlateReader {
    static func plate(from body: EventBody) -> RecognizedPlate? {
        let sources = sources(from: body)
        guard let winnerIndex = sources.firstIndex(where: { bestHypothesis($0.hypotheses) != nil }),
              let hypothesis = bestHypothesis(sources[winnerIndex].hypotheses) else {
            return nil
        }

        return RecognizedPlate(
            number: hypothesis.number,
            country: hypothesis.country ?? firstCountry(in: sources, after: winnerIndex),
            plateType: firstPlateType(in: sources),
            color: firstAttribute(in: sources, keys: ["vehicle_color", "VehicleColor"]),
            brand: firstAttribute(in: sources, keys: ["vehicle_brand", "VehicleBrand"]),
            model: firstAttribute(in: sources, keys: ["vehicle_model", "VehicleModel"]),
            vehicleClass: WireEnum.first(
                VehicleClass.self,
                in: sources.map { (result: $0.result, data: $0.vehicleClass) },
                keys: ["vehicle_class", "VehicleClass"],
                hiding: .unknown
            ),
            headlights: WireEnum.first(
                HeadlightsStatus.self,
                in: sources.map { (result: $0.result, data: $0.headlights) },
                keys: ["headlights_status", "HeadlightsStatus"],
                hiding: .undefined
            ),
            direction: WireEnum.first(
                Direction.self,
                in: sources.map { (result: $0.result, data: $0.direction) },
                keys: ["direction", "Direction"],
                hiding: .unknown
            ),
            rectangle: hypothesis.rectangle
        )
    }

    private struct Source {
        var hypotheses: [JSONValue]
        var result: JSONValue?
        var dataColor: String?
        var dataBrand: String?
        var dataModel: String?
        var plateType: SafeEnum<PlateType>?
        var vehicleClass: SafeEnum<VehicleClass>?
        var direction: SafeEnum<Direction>?
        var headlights: SafeEnum<HeadlightsStatus>?
    }

    private struct Hypothesis {
        var quality: Double
        var number: String
        var country: String?
        var rectangle: RecognizedPlate.PlateRectangle?
    }

    private static func sources(from body: EventBody) -> [Source] {
        var sources: [Source] = []
        for details in body.details ?? [] {
            if let result = details.autoRecognitionResult {
                sources.append(Source(hypotheses: hypotheses(in: result), result: result))
            }
        }
        for details in body.details ?? [] {
            if let result = details.autoRecognitionResultEx {
                sources.append(Source(hypotheses: hypotheses(in: result), result: result))
            }
        }
        if let data = body.data {
            sources.append(Source(
                hypotheses: data.hypotheses ?? [],
                result: nil,
                dataColor: data.vehicleColor,
                dataBrand: data.vehicleBrand,
                dataModel: data.vehicleModel,
                plateType: data.plateType,
                vehicleClass: data.vehicleClass,
                direction: data.direction,
                headlights: data.headlights
            ))
        }
        return sources
    }

    private static func hypotheses(in result: JSONValue) -> [JSONValue] {
        result["hypotheses"]?.arrayValue ?? result["Hypotheses"]?.arrayValue ?? []
    }

    private static func bestHypothesis(_ hypotheses: [JSONValue]) -> Hypothesis? {
        var best: Hypothesis?
        for value in hypotheses {
            guard let number = showable(value["plate_full"]?.stringValue ?? value["PlateFull"]?.stringValue) else {
                continue
            }
            let quality = value["ocr_quality"]?.doubleValue ?? value["OCRQuality"]?.doubleValue ?? -.greatestFiniteMagnitude
            let candidate = Hypothesis(
                quality: quality,
                number: number,
                country: showable(value["country"]?.stringValue ?? value["PlateCountry"]?.stringValue),
                rectangle: rectangle(from: value["plate_rectangle"] ?? value["PlateRectangle"])
            )
            if best == nil || candidate.quality > best!.quality {
                best = candidate
            }
        }
        return best
    }

    private static func firstCountry(in sources: [Source], after index: Int) -> String? {
        for source in sources.dropFirst(index + 1) {
            if let country = bestHypothesis(source.hypotheses)?.country {
                return country
            }
        }
        return nil
    }

    private static func firstPlateType(in sources: [Source]) -> PlateType? {
        for source in sources {
            if let result = source.result,
               let raw = unwrappedString(result["plate_type"] ?? result["PlateType"]) {
                guard let type = plateType(named: raw), type != .unknownPlateType else { return nil }
                return type
            }
            if let type = source.plateType?.value, type != .unknownPlateType {
                return type
            }
        }
        return nil
    }

    private static func plateType(named raw: String) -> PlateType? {
        let folded = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return PlateType.allCases.first { ("e" + String(describing: $0)).lowercased() == folded }
    }

    private static func firstAttribute(in sources: [Source], keys: [String]) -> String? {
        for source in sources {
            if let result = source.result {
                for key in keys {
                    if let value = showable(unwrappedString(result[key])) {
                        return value
                    }
                }
            }
            for key in keys {
                let fallback: String?
                switch key {
                case "vehicle_color", "VehicleColor":
                    fallback = source.dataColor
                case "vehicle_brand", "VehicleBrand":
                    fallback = source.dataBrand
                case "vehicle_model", "VehicleModel":
                    fallback = source.dataModel
                default:
                    fallback = nil
                }
                if let value = showable(fallback) {
                    return value
                }
            }
        }
        return nil
    }

    private static func rectangle(from value: JSONValue?) -> RecognizedPlate.PlateRectangle? {
        guard let value else { return nil }
        if let minX = value["x"]?.doubleValue,
           let minY = value["y"]?.doubleValue,
           let width = value["w"]?.doubleValue,
           let height = value["h"]?.doubleValue,
           width > 0, height > 0 {
            return RecognizedPlate.PlateRectangle(minX: minX, minY: minY, width: width, height: height)
        }
        guard let corners = value.arrayValue, corners.count >= 4,
              let minX = corners[0].doubleValue,
              let minY = corners[1].doubleValue,
              let maxX = corners[2].doubleValue,
              let maxY = corners[3].doubleValue else {
            return nil
        }
        let width = maxX - minX
        let height = maxY - minY
        guard width > 0, height > 0 else { return nil }
        return RecognizedPlate.PlateRectangle(minX: minX, minY: minY, width: width, height: height)
    }

    private static func unwrappedString(_ value: JSONValue?) -> String? {
        guard let value else { return nil }
        if let string = value.stringValue {
            return string
        }
        return value["value"]?.stringValue
    }

    /// Drops empty text, `Undefined`, and any value that contains `Unknown`.
    private static func showable(_ raw: String?) -> String? {
        guard let raw else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != "Undefined", !trimmed.contains("Unknown") else {
            return nil
        }
        return trimmed
    }
}
