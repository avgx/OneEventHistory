import Foundation
import Testing
@testable import OneEventHistory

@Suite("Audit SearchFilter")
struct AuditSearchFilterTests {
    @Test("audit filter encodes ET_Audit and operation names")
    func auditFilterEncoding() throws {
        let filter = SearchFilter.audit(operations: [.userLogin, .cameraViewing])
        let data = try JSONEncoder().encode(filter)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        #expect(json["type"] as? String == "ET_Audit")
        #expect(json["values"] as? [String] == ["AE_USER_LOGIN", "AE_CAMERA_VIEWING"])
    }

    @Test("audit without operations requests all ET_Audit")
    func auditAll() throws {
        let filter = SearchFilter.audit()
        #expect(filter.type == .audit)
        #expect(filter.values.isEmpty)
    }

    @Test("AuditEventType wire numbers match Events.proto")
    func wireNumbers() {
        #expect(AuditEventType.userLogin.wireNumber == 13)
        #expect(AuditEventType.cameraViewing.wireNumber == 50)
        #expect(AuditEventType.ptzControl.wireNumber == 63)
        #expect(AuditEventType.notSpecified.wireNumber == 0)
    }
}
