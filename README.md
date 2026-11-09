# swift-git-standard

Use this package when you already have bytes that Git printed and need them as values: the porcelain status of a working tree, or the reference list a remote advertises. Start from `Git.Status.parse(_:)` or `Git.Ref.Advertisement.parse(_:)`, and use `Git.Ref.Name` and `Git.Object.ID` to validate names and object IDs on their own. The package never runs Git. To run Git commands, use swift-git.

## Laws

- `Git.Status.parse(_:)` reads the NUL-separated porcelain v1 status that git status prints with -z. Each entry is two status letters, a space and a NUL-terminated path. When either letter is renamed or copied, a second NUL-terminated path follows and becomes the entry's `origin`.
- Status paths stay raw bytes. They are not decoded, so names with spaces or in any encoding come through unchanged.
- `Git.Ref.Advertisement.parse(_:)` reads one object ID, a tab and a reference name per line, with lines separated by LF. Empty lines are skipped. A line without exactly one tab is refused.
- Every parse error carries the byte offset where the problem starts.
- `Git.Object.ID` is 40 or 64 hexadecimal digits, so both SHA-1 and SHA-256 IDs are accepted. Upper and lower case are both accepted and kept as given.
- `Git.Ref.Name` follows the rules of `git check-ref-format` and also needs at least one slash, so a short name such as `main` is refused while `refs/heads/main` is accepted. Non-ASCII names are accepted.
- A peeled tag line from a remote, whose name ends in `^{}`, parses as a record under the tag's name with `isPeeled` set; its object is what the annotated tag points to.
