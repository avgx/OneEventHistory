import Foundation
import SafeEnum

/// Detector-side error returned by similarity and prompt RPCs (`errors.DetectorError`).
public struct DetectorError: Decodable, Equatable, Sendable {
    public let code: SafeEnum<DetectorErrorCode>?
    public let message: String?

    public init(code: SafeEnum<DetectorErrorCode>? = nil, message: String? = nil) {
        self.code = code
        self.message = message
    }
}

/// Known detector error codes.
public enum DetectorErrorCode: String, Decodable, Equatable, Sendable {
    case notError = "NotError"
    case generalError = "GeneralError"
    case invalidArgument = "InvalidArgument"
}
