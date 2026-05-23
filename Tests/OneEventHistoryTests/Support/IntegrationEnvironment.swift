import Foundation

enum IntegrationEnvironment {
    static var merged: [String: String] {
        var result = ProcessInfo.processInfo.environment
        for url in candidateEnvFiles() {
            mergeEnvFile(at: url, into: &result)
        }
        return result
    }

    static func value(_ key: String) -> String? {
        guard let raw = merged[key], !raw.isEmpty else { return nil }
        return raw
    }

    private static func candidateEnvFiles() -> [URL] {
        let file = URL(fileURLWithPath: #filePath)
        let testsTargetDir = file.deletingLastPathComponent().deletingLastPathComponent()
        let packageRoot = testsTargetDir.deletingLastPathComponent().deletingLastPathComponent()
        return [
            packageRoot.appendingPathComponent(".env"),
            testsTargetDir.appendingPathComponent(".env"),
        ]
    }

    private static func mergeEnvFile(at url: URL, into result: inout [String: String]) {
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else { return }

        for line in contents.split(whereSeparator: \.isNewline) {
            var line = String(line).trimmingCharacters(in: .whitespaces)
            if line.isEmpty || line.hasPrefix("#") { continue }
            if line.hasPrefix("export ") {
                line.removeFirst("export ".count)
            }
            guard let separator = line.firstIndex(of: "=") else { continue }

            let key = line[..<separator].trimmingCharacters(in: .whitespaces)
            var value = line[line.index(after: separator)...].trimmingCharacters(in: .whitespaces)
            if (value.hasPrefix("\"") && value.hasSuffix("\"")) || (value.hasPrefix("'") && value.hasSuffix("'")) {
                value.removeFirst()
                value.removeLast()
            }
            guard !key.isEmpty else { continue }
            if result[key] == nil {
                result[key] = value
            }
        }
    }
}

enum EventHistoryIntegrationConfig {
    static let integrationFlag = "ONEEVENTHISTORY_TEST_INTEGRATION"
    static let saveFlag = "ONEEVENTHISTORY_SAVE_DATA"
    static let baseURLKey = "ONEEVENTHISTORY_TEST_URL"
    static let userKey = "ONEEVENTHISTORY_USER"
    static let passKey = "ONEEVENTHISTORY_PASS"
    static let jpegKey = "ONEEVENTHISTORY_TEST_JPEG"

    static var isIntegrationEnabled: Bool {
        IntegrationEnvironment.value(integrationFlag) == "1"
    }

    static var isSaveEnabled: Bool {
        IntegrationEnvironment.value(saveFlag) == "1"
    }

    static func credentials() -> (baseURL: URL, user: String, password: String)? {
        guard let baseURLString = IntegrationEnvironment.value(baseURLKey),
              let user = IntegrationEnvironment.value(userKey),
              let password = IntegrationEnvironment.value(passKey),
              let baseURL = URL(string: baseURLString) else {
            return nil
        }
        return (baseURL, user, password)
    }

    static var testJPEGBase64: String? {
        IntegrationEnvironment.value(jpegKey)
    }
}
