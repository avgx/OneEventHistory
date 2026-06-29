import Foundation

public struct LocalizedText: Codable, Equatable, Sendable {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}
