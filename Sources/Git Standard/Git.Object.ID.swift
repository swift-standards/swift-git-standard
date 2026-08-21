extension Git.Object {

    public struct ID: Sendable, Equatable, Hashable, RawRepresentable {
        public let rawValue: String

        public init(_ rawValue: String) throws(Error) {
            let bytes = Array(rawValue.utf8)
            guard
                bytes.count == 40 || bytes.count == 64,
                bytes.allSatisfy({
                    (48...57).contains($0) || (65...70).contains($0) || (97...102).contains($0)
                })
            else {
                throw .invalid(rawValue)
            }
            self.rawValue = rawValue
        }

        public init?(rawValue: String) {
            do throws(Error) {
                try self.init(rawValue)
            } catch {
                return nil
            }
        }
    }
}
