import Foundation
import SafeEnum

public struct FaceRecognitionResult: Decodable, Equatable, Sendable {
    public let beginTime: String
    public let bestQuality: Double
    public let evasionType: SafeEnum<EvasionType>
    public let age: Int
    public let gender: SafeEnum<Gender>

    private enum CodingKeys: String, CodingKey {
        case beginTime = "begin_time"
        case bestQuality = "best_quality"
        case evasionType = "evasion_type"
        case age
        case gender
    }
}
