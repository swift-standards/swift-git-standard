extension Git.Ref.Advertisement {
    public enum Error: Swift.Error, Sendable, Equatable {
        case syntax(Int)
        case object(String)
        case name(String)
    }
}
