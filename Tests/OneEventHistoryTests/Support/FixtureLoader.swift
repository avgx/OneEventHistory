import Foundation

enum FixtureLoader {
    static func data(named name: String, extension ext: String) throws -> Data {
        if let bundled = Bundle.module.url(forResource: name, withExtension: ext) {
            return try Data(contentsOf: bundled)
        }
        throw URLError(.fileDoesNotExist, userInfo: [NSURLErrorKey: "\(name).\(ext)"])
    }

    static func string(named name: String, extension ext: String) throws -> String {
        let data = try data(named: name, extension: ext)
        guard let string = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return string
    }

    static func saveRawFixture(named name: String, extension ext: String, data: Data) throws -> URL {
        let directory = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Resources", isDirectory: true)
        let fileURL = directory.appendingPathComponent("\(name).\(ext)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }
}
