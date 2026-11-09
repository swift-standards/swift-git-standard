extension Git.Ref {

    public struct Advertisement: Sendable, Equatable {
        public let object: Git.Object.ID
        public let name: Git.Ref.Name

        /// Whether this record is a peeled tag line, `<name>^{}` in `git ls-remote` output:
        /// `object` is then what the annotated tag `name` points to, not the tag itself.
        public let isPeeled: Bool

        public init(object: Git.Object.ID, name: Git.Ref.Name, isPeeled: Bool = false) {
            self.object = object
            self.name = name
            self.isPeeled = isPeeled
        }
    }
}

extension Git.Ref.Advertisement {
    static let peeledSuffix = "^{}"

    public static func parse(_ bytes: [UInt8]) throws(Error) -> [Self] {
        var records: [Self] = []
        var start = bytes.startIndex

        while start < bytes.endIndex {
            let end = bytes[start...].firstIndex(of: 10) ?? bytes.endIndex
            let line = bytes[start..<end]
            if !line.isEmpty {
                guard let tab = line.firstIndex(of: 9),
                    line[line.index(after: tab)...].firstIndex(of: 9) == nil
                else {
                    throw .syntax(start)
                }
                let objectText = String(decoding: line[..<tab], as: UTF8.self)
                let nameText = String(decoding: line[line.index(after: tab)...], as: UTF8.self)
                guard let object = Git.Object.ID(rawValue: objectText) else {
                    throw .object(objectText)
                }
                let isPeeled = nameText.hasSuffix(Self.peeledSuffix)
                let refText = isPeeled ? String(nameText.dropLast(Self.peeledSuffix.count)) : nameText
                guard let name = Git.Ref.Name(rawValue: refText) else {
                    throw .name(nameText)
                }
                records.append(.init(object: object, name: name, isPeeled: isPeeled))
            }
            start = end == bytes.endIndex ? end : bytes.index(after: end)
        }
        return records
    }
}
