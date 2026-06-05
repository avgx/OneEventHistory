import Foundation
import JSONValue

public extension Event {

    /// Wire access point of the camera/source, when present in the payload.
    public var cameraAccessPoint: String? {
        if let accessPoint = body.originExt?["access_point"]?.stringValue, !accessPoint.isEmpty {
            return accessPoint
        }
        if let origin = body.originDeprecated, !origin.isEmpty {
            return origin
        }
        if let accessPoint = body.camera?["access_point"]?.stringValue, !accessPoint.isEmpty {
            return accessPoint
        }
        if let originID = body.data?.originId, !originID.isEmpty {
            return originID
        }
        return subjects.first(where: { $0.contains("/") })
    }

    /// Human-readable camera name from wire payload (`origin_ext` / macro `camera`).
    public var cameraFriendlyName: String? {
        if let name = body.originExt?["friendly_name"]?.stringValue, !name.isEmpty {
            return name
        }
        if let name = body.camera?["friendly_name"]?.stringValue, !name.isEmpty {
            return name
        }
        return nil
    }
}
