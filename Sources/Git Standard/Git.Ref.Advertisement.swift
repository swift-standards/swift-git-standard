extension Git.Ref {
    /// One `<oid> TAB <ref> LF` record emitted by `git ls-remote --refs`.
    public struct Advertisement: Sendable, Equatable {
        public let object: Git.Object.ID
        public let name: Git.Ref.Name

        public init(object: Git.Object.ID, name: Git.Ref.Name) {
            self.object = object
            self.name = name
        }

        public static func parse(_ bytes: [UInt8]) throws(Error) -> [Self] {
            var records: [Self] = []
            var start = bytes.startIndex

            while start < bytes.endIndex {
                let end = bytes[start...].firstIndex(of: 10) ?? bytes.endIndex
                let line = bytes[start..<end]
                if !line.isEmpty {
                    guard let tab = line.firstIndex(of: 9), line[line.index(after: tab)...].firstIndex(of: 9) == nil else {
                        throw .syntax(start)
                    }
                    let objectText = String(decoding: line[..<tab], as: UTF8.self)
                    let nameText = String(decoding: line[line.index(after: tab)...], as: UTF8.self)
                    guard let object = Git.Object.ID(rawValue: objectText) else {
                        throw .object(objectText)
                    }
                    guard let name = Git.Ref.Name(rawValue: nameText) else {
                        throw .name(nameText)
                    }
                    records.append(.init(object: object, name: name))
                }
                start = end == bytes.endIndex ? end : bytes.index(after: end)
            }
            return records
        }
    }
}
