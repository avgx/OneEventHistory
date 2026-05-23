import Foundation
import Testing
@testable import OneEventHistory

@Suite("ReadAlerts decoding")
struct ReadAlertsDecodingTests {
    @Test("decode ReadAlertsPage synthetic JSON")
    func decodePage() throws {
        let json = """
        {
          "items": [],
          "unreachable_subjects": ["hosts/Offline/Cameras.1"]
        }
        """
        let page = try JSONDecoder().decode(ReadAlertsPage.self, from: Data(json.utf8))
        #expect(page.items.isEmpty)
        #expect(page.unreachableSubjects?.count == 1)
    }
}
