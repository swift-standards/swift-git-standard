extension Git.Object.ID {
    public enum Error: Swift.Error, Sendable, Equatable {
        case invalid(String)
    }
}
