extension Git.Ref {
    /// A fully qualified Git reference name.
    public struct Name: Sendable, Equatable, Hashable, RawRepresentable {
        public let rawValue: String

        public init(_ rawValue: String) throws(Error) {
            let bytes = Array(rawValue.utf8)
            guard
                rawValue != "@",
                bytes.contains(47),
                bytes.first != 47,
                bytes.last != 47,
                bytes.last != 46,
                !bytes.contains(92),
                !rawValue.contains("//"),
                !rawValue.contains(".."),
                !rawValue.contains("@{")
            else {
                throw .invalid(rawValue)
            }

            for byte in bytes {
                guard
                    byte >= 32,
                    byte != 127,
                    ![32, 126, 94, 58, 63, 42, 91].contains(byte)
                else {
                    throw .invalid(rawValue)
                }
            }

            for component in rawValue.split(separator: "/", omittingEmptySubsequences: false) {
                guard
                    !component.isEmpty,
                    component.first != ".",
                    !component.hasSuffix(".lock")
                else {
                    throw .invalid(rawValue)
                }
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
