extension Git.Status {
    public enum Error: Swift.Error, Sendable, Equatable {
        case syntax(Int)
        case code(UInt8, Int)
        case path(Int)
    }
}
