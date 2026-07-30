import Testing

@testable import Git_Standard

extension Git.Ref.Name {
    @Suite
    struct Test {
        @Test
        func `qualified reference is accepted`() throws {
            let name = try Git.Ref.Name("refs/heads/main")
            #expect(name.rawValue == "refs/heads/main")
        }

        @Test(arguments: [
            "main", "refs//main", "refs/.main", "refs/main.lock", "refs/main..next",
            "refs/main\\next",
        ])
        func `invalid reference is rejected`(_ value: String) {
            #expect(throws: Git.Ref.Name.Error.self) {
                try Git.Ref.Name(value)
            }
        }
    }
}
