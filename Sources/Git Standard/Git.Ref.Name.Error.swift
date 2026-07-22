extension Git.Ref.Name {
    public enum Error: Swift.Error, Sendable, Equatable {
        case invalid(String)
    }
}
