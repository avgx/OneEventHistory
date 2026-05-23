import Foundation

public struct Rectangle: Decodable, Equatable, Sendable {
    public let x: Double
    public let y: Double
    public let w: Double
    public let h: Double
    public let index: Int
}
