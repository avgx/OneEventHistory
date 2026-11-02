import Foundation
import JSONValue

/// One list a `listed_lpr_detected` event was matched against.
public struct ListedItemBinding: Equatable, Sendable, Identifiable {
    public let listID: String
    public let listName: String?

    public var id: String { listID }

    public init(listID: String, listName: String?) {
        self.listID = listID
        self.listName = listName
    }
}

enum ListedItemBindingReader {
    /// Reads `lists_info`, then the deprecated single `list_id` / `list_name`.
    static func bindings(from value: JSONValue) -> [ListedItemBinding] {
        if let items = value["lists_info"]?.arrayValue {
            let bindings = items.compactMap(binding(from:))
            if !bindings.isEmpty { return bindings }
        }
        if let one = binding(from: value) { return [one] }
        return []
    }

    private static func binding(from value: JSONValue) -> ListedItemBinding? {
        guard let listID = value["list_id"]?.stringValue, !listID.isEmpty else { return nil }
        let name = value["list_name"]?.stringValue
        return ListedItemBinding(listID: listID, listName: name?.isEmpty == true ? nil : name)
    }
}
