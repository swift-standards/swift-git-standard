extension Git.Status {
    public struct Entry: Sendable, Equatable {
        public let index: Code
        public let tree: Code
        public let path: [UInt8]
        public let origin: [UInt8]?

        public init(index: Code, tree: Code, path: [UInt8], origin: [UInt8]? = nil) {
            self.index = index
            self.tree = tree
            self.path = path
            self.origin = origin
        }
    }
}
