import Foundation
import OneWireFormat
import Presentable
import RequestResponse

/// `RealtimeRecognizerService` via `POST /grpc`.
public enum RecognizerApi {
    public static let getListStreamMethod = "axxonsoft.bl.realtimerecognizer.RealtimeRecognizerService.GetListStream"
    public static let getListsMethod = "axxonsoft.bl.realtimerecognizer.RealtimeRecognizerService.GetLists"
    public static let getItemsMethod = "axxonsoft.bl.realtimerecognizer.RealtimeRecognizerService.GetItems"

    public static let lprListType = "ELT_LPR"

    /// Stream of lists. Empty `listId` asks for every list of `type`. Read until `EPS_LAST`.
    ///
    /// A live server returns one empty `EPS_LAST` page and no lists. Call ``getLists(type:nodeName:)``.
    public static func getListStream(
        listId: String = "",
        type: String = lprListType,
        nodeName: String
    ) -> Request<PagedResponse<GetListStreamResponse>> {
        grpcStream(
            method: getListStreamMethod,
            data: GetListStreamRequest(listId: listId, type: type, nodeName: nodeName)
        )
    }

    /// Unary list call. Deprecated in the service, and the call that returns lists. Desktop uses it.
    public static func getLists(
        type: String = lprListType,
        nodeName: String
    ) -> Request<GetListsResponse> {
        Request(
            path: "/grpc",
            method: .post,
            body: GrpcEnvelope(
                method: getListsMethod,
                data: GetListsRequest(type: type, nodeName: nodeName)
            )
        )
    }

    /// Items of a list. Plate text is `data_string`.
    public static func getItems(
        itemIDs: [String],
        nodeName: String
    ) -> Request<PagedResponse<GetItemsResponse>> {
        grpcStream(
            method: getItemsMethod,
            data: GetItemsRequest(itemIDs: itemIDs, nodeName: nodeName)
        )
    }

    private static func grpcStream<Body: Encodable & Sendable, Page: Decodable & Sendable>(
        method: String,
        data: Body
    ) -> Request<PagedResponse<Page>> {
        Request(
            path: "/grpc",
            method: .post,
            body: GrpcEnvelope(method: method, data: data)
        )
    }
}

/// Why a recognizer call failed.
///
/// ``shouldFallbackToGetLists`` is true only for gRPC `UNIMPLEMENTED`.
/// `GetListStream` does not fail that way: it returns an empty page, so the client calls `GetLists` directly.
public enum RecognizerCallError: Error, Equatable, Sendable, LocalizedError {
    case unimplemented
    case permissionDenied
    case unavailable
    case failed(String)

    public var errorDescription: String? {
        switch self {
        case .unimplemented:
            return "This server does not provide license plate lists."
        case .permissionDenied:
            return "You do not have permission to read license plate lists."
        case .unavailable:
            return "The license plate recognizer is unavailable."
        case .failed(let message):
            return message
        }
    }

    public var shouldFallbackToGetLists: Bool {
        self == .unimplemented
    }

    /// gRPC `UNIMPLEMENTED` is 12. Other codes stay on the original call.
    public static func from(grpcCode: Int?) -> RecognizerCallError {
        switch grpcCode {
        case 12:
            return .unimplemented
        case 7:
            return .permissionDenied
        case 14:
            return .unavailable
        default:
            return .failed(grpcCode.map(String.init) ?? "unknown")
        }
    }
}

public struct GetListStreamRequest: Encodable, Sendable {
    public let listId: String
    public let type: String
    public let nodeName: String

    private enum CodingKeys: String, CodingKey {
        case listId = "list_id"
        case type
        case nodeName = "node_name"
    }

    public init(listId: String, type: String, nodeName: String) {
        self.listId = listId
        self.type = type
        self.nodeName = nodeName
    }
}

public struct GetListStreamResponse: Decodable, Equatable, Sendable {
    public let status: RecognizerPacketStatus?
    public let list: NamedList<String>?

    public var isLast: Bool { status?.isLast == true }

    private enum CodingKeys: String, CodingKey {
        case status
        case list
    }

    public init(status: RecognizerPacketStatus?, list: NamedList<String>?) {
        self.status = status
        self.list = list
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(RecognizerPacketStatus.self, forKey: .status)
        list = try container.decodeIfPresent(RecognizerListWire.self, forKey: .list)?.list
    }
}

/// `EPacketStatus`. Servers send either the name or the ordinal.
public struct RecognizerPacketStatus: Decodable, Equatable, Sendable {
    public let isLast: Bool

    public init(isLast: Bool) {
        self.isLast = isLast
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let name = try? container.decode(String.self) {
            isLast = name == "EPS_LAST"
            return
        }
        if let number = try? container.decode(Int.self) {
            isLast = number == 1
            return
        }
        isLast = false
    }
}

struct RecognizerListWire: Decodable {
    let list: NamedList<String>

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case itemIDs = "item_ids"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = NamedList(
            id: try container.decode(String.self, forKey: .id),
            name: try container.decodeIfPresent(String.self, forKey: .name) ?? "",
            items: try container.decodeIfPresent([String].self, forKey: .itemIDs) ?? []
        )
    }
}

public struct GetListsRequest: Encodable, Sendable {
    public let type: String
    public let nodeName: String

    private enum CodingKeys: String, CodingKey {
        case type
        case nodeName = "node_name"
    }

    public init(type: String, nodeName: String) {
        self.type = type
        self.nodeName = nodeName
    }
}

public struct GetListsResponse: Decodable, Equatable, Sendable {
    public let lists: [NamedList<String>]

    private enum CodingKeys: String, CodingKey {
        case lists
    }

    public init(lists: [NamedList<String>]) {
        self.lists = lists
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lists = try container.decode([RecognizerListWire].self, forKey: .lists).map(\.list)
    }
}

public struct GetItemsRequest: Encodable, Sendable {
    public let requiredItems: [RequiredRecognizerItem]
    public let nodeName: String

    private enum CodingKeys: String, CodingKey {
        case requiredItems = "required_items"
        case nodeName = "node_name"
    }

    public init(itemIDs: [String], nodeName: String) {
        self.requiredItems = itemIDs.map { RequiredRecognizerItem(itemId: $0) }
        self.nodeName = nodeName
    }
}

public struct RequiredRecognizerItem: Encodable, Sendable {
    public let itemId: String

    private enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
    }
}

public struct GetItemsResponse: Decodable, Equatable, Sendable {
    public let status: RecognizerPacketStatus?
    public let item: RecognizerItemWire?

    public var isLast: Bool { status?.isLast == true }
}

public struct RecognizerItemWire: Decodable, Equatable, Sendable {
    public let id: String
    public let dataString: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case dataString = "data_string"
    }

    public var plate: String? {
        guard let dataString, !dataString.isEmpty else { return nil }
        return dataString
    }
}

public enum RecognizerListParsing {
    public static func lists(from pages: [GetListStreamResponse]) -> [NamedList<String>] {
        pages.compactMap(\.list)
    }

    public static func plates(from pages: [GetItemsResponse]) -> [String] {
        pages.compactMap { $0.item?.plate }
    }
}
