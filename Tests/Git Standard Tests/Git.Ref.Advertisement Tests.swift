import Testing

@testable import Git_Standard

enum `Git.Ref.Advertisement Tests` {}

extension `Git.Ref.Advertisement Tests` {
    @Suite
    struct Test {
        @Test
        func `remote record is parsed`() throws {
            let bytes = Array("0123456789012345678901234567890123456789\trefs/heads/main\n".utf8)
            let records = try Git.Ref.Advertisement.parse(bytes)

            #expect(records.count == 1)

            #expect(records.first?.name.rawValue == "refs/heads/main")
        }

        @Test
        func `peeled tag record is parsed under the tag name`() throws {
            let bytes = Array(
                ("0123456789012345678901234567890123456789\trefs/tags/v1.0.0\n"
                    + "abcdefabcdefabcdefabcdefabcdefabcdefabcd\trefs/tags/v1.0.0^{}\n").utf8
            )
            let records = try Git.Ref.Advertisement.parse(bytes)

            #expect(records.count == 2)
            #expect(records.map(\.name.rawValue) == ["refs/tags/v1.0.0", "refs/tags/v1.0.0"])
            #expect(records.map(\.isPeeled) == [false, true])
            #expect(records.last?.object.rawValue == "abcdefabcdefabcdefabcdefabcdefabcdefabcd")
        }

        @Test
        func `a caret elsewhere in the name is still rejected`() {
            #expect(throws: Git.Ref.Advertisement.Error.name("refs/tags/v^1")) {
                try Git.Ref.Advertisement.parse(
                    Array("0123456789012345678901234567890123456789\trefs/tags/v^1\n".utf8)
                )
            }
        }

        @Test
        func `malformed record is rejected`() {
            #expect(throws: Git.Ref.Advertisement.Error.self) {
                try Git.Ref.Advertisement.parse(Array("not-a-record\n".utf8))
            }
        }
    }
}
