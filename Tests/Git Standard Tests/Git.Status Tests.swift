import Testing

@testable import Git_Standard

extension Git.Status {
    @Suite
    struct Test {
        @Test
        func `ordinary and renamed entries are parsed without path decoding`() throws {
            let bytes = Array(" M file with space.swift\0R  new.swift\0old.swift\0".utf8)
            let entries = try Git.Status.parse(bytes)

            #expect(entries.count == 2)
            #expect(entries[0].tree == .modified)
            #expect(entries[0].path == Array("file with space.swift".utf8))
            #expect(entries[1].index == .renamed)
            #expect(entries[1].path == Array("new.swift".utf8))
            #expect(entries[1].origin == Array("old.swift".utf8))
        }

        @Test
        func `truncated entry is rejected`() {
            #expect(throws: Git.Status.Error.self) {
                try Git.Status.parse(Array(" M path".utf8))
            }
        }
    }
}
