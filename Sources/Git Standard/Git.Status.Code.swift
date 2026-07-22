extension Git.Status {
    public enum Code: UInt8, Sendable, Equatable, Hashable {
        case unmodified = 32
        case modified = 77
        case type = 84
        case added = 65
        case deleted = 68
        case renamed = 82
        case copied = 67
        case unmerged = 85
        case untracked = 63
        case ignored = 33
    }
}
