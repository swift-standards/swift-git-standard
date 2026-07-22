extension Git {
    /// Git porcelain status version 1 in NUL-delimited machine form.
    public enum Status: Sendable {
        public static func parse(_ bytes: [UInt8]) throws(Error) -> [Entry] {
            var entries: [Entry] = []
            var start = bytes.startIndex

            while start < bytes.endIndex {
                guard bytes.distance(from: start, to: bytes.endIndex) >= 4 else {
                    throw .syntax(start)
                }
                let treeIndex = bytes.index(after: start)
                let space = bytes.index(after: treeIndex)
                guard bytes[space] == 32 else {
                    throw .syntax(start)
                }
                guard let index = Code(rawValue: bytes[start]) else {
                    throw .code(bytes[start], start)
                }
                guard let tree = Code(rawValue: bytes[treeIndex]) else {
                    throw .code(bytes[treeIndex], treeIndex)
                }

                let pathStart = bytes.index(after: space)
                guard let pathEnd = bytes[pathStart...].firstIndex(of: 0), pathStart != pathEnd else {
                    throw .path(pathStart)
                }
                let path = Array(bytes[pathStart..<pathEnd])
                start = bytes.index(after: pathEnd)

                let moved = index == .renamed || index == .copied || tree == .renamed || tree == .copied
                let origin: [UInt8]?
                if moved {
                    guard let originEnd = bytes[start...].firstIndex(of: 0), start != originEnd else {
                        throw .path(start)
                    }
                    origin = Array(bytes[start..<originEnd])
                    start = bytes.index(after: originEnd)
                } else {
                    origin = nil
                }
                entries.append(.init(index: index, tree: tree, path: path, origin: origin))
            }
            return entries
        }
    }
}
