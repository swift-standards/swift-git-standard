# swift-git-standard

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Foundation-free representations and parsers for externally defined Git repository, reference-advertisement, and porcelain-status formats.

---

## Quick Start

Parse the NUL-delimited porcelain status emitted by `git status --porcelain=v1 -z`:

```swift
import Git_Standard

let entries = try Git.Status.parse(Array(" M Package.swift\0".utf8))
for entry in entries {
    print(entry.path)
}
```

The package models bytes and state only. Executing Git belongs to [swift-git](https://github.com/swift-foundations/swift-git).

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-git-standard.git", branch: "main")
]
```

Use the `Git Standard` product and import `Git_Standard`.

### Requirements

- Swift 6.3+
- Apple platforms 26+ and Linux

---

## Architecture

- `Git.Object.ID` validates hexadecimal object identifiers.
- `Git.Ref.Name` models qualified Git reference names.
- `Git.Ref.Advertisement` parses `ls-remote` records.
- `Git.Status` parses porcelain-v1 status records without invoking a process.

Repository layout, config, index, pack, and wire-protocol formats will enter this package only with implemented, specification-backed surfaces.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at the first public release.*
<!-- END: discussion -->

---

## License

Apache 2.0. See [LICENSE](LICENSE.md).
