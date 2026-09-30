import Testing

@testable import Git_Standard

@Suite
struct `Git reference name boundaries` {
    @Test(arguments: [
        "@", "", "/refs/heads/main", "refs/heads/main/", "refs/heads/main.",
        "refs/heads/a@{b", "refs/heads/a b", "refs/heads/a~b", "refs/heads/a^b", "refs/heads/a:b",
        "refs/heads/a?b", "refs/heads/a*b", "refs/heads/a[b", "refs/heads/a\u{7F}b", "refs/heads/a\u{1F}b",
        "refs/heads/.hidden", "refs/heads/x.lock",
    ])
    func `every check-ref-format rule rejects its case`(_ value: String) {
        #expect(throws: Git.Ref.Name.Error.self) { try Git.Ref.Name(value) }
        #expect(Git.Ref.Name(rawValue: value) == nil)
    }

    @Test(arguments: [
        "refs/heads/a.lock.b", "refs/heads/@", "refs/heads/a@b", "refs/heads/café", "refs/tags/v1.0.0",
        "refs/heads/a.b", "refs/heads/-dash",
    ])
    func `near misses of the rules are accepted`(_ value: String) throws {
        #expect(try Git.Ref.Name(value).rawValue == value)
    }
}
