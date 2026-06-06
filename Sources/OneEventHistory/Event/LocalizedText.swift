import Foundation

public struct LocalizedText: Decodable, Equatable, Sendable {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}
