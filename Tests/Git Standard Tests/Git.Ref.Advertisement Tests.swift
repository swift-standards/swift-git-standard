import Testing

@testable import Git_Standard

extension Git.Ref.Advertisement {
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
        func `malformed record is rejected`() {
            #expect(throws: Git.Ref.Advertisement.Error.self) {
                try Git.Ref.Advertisement.parse(Array("not-a-record\n".utf8))
            }
        }
    }
}
