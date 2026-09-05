# Agent guide

Runnable Swift examples for the Payam Resan SMS web service. One file per API
method, and every file has to work on its own.

## Rule one: no dependencies, and no package

An example runs on a stock Swift toolchain and nothing else. `URLSession` and
`JSONSerialization` both live in Foundation, so there is no SwiftPM package
here, no `Package.swift`, and nothing to resolve.

Each file runs directly:

```bash
swift examples/v3/account-info.swift
```

That also rules out helpers from this repository. There is no shared client
type here and there should not be one: a function defined in `Sources/` means
nothing to somebody reading the file on the documentation site.

## Rule two: the FoundationNetworking import is not optional

On Apple platforms `URLSession` is part of Foundation. On Linux it was split
into a separate module, so every file opens with:

```swift
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
```

Without it the examples do not build on Linux, which is where they are tested
and where a fair number of readers run their server code. The `#if` makes it a
no-op on macOS and iOS, so the same file works everywhere. Do not "tidy" it
away.

## Rule three: the body sits inside do/catch, and that is Swift's doing

Top-level code cannot let an error propagate, so `try` at the top level is a
compile error unless it is caught. Every example therefore wraps its body in a
single `do/catch`, and the `catch` reports the failure and exits non-zero.

That is not decoration. It splits the two kinds of failure a reader has to tell
apart: a timeout or a DNS failure lands in `catch`, while the service answering
`Success: false` is handled by the guard described below. Reporting them the
same way teaches the wrong thing.

Top-level `await` inside that block works in script mode, so the examples use
the async `URLSession` API rather than completion handlers or a semaphore.

## Rule four: the examples are the documentation

Each file carries `// docs:start` and `// docs:end`. The region between them is
lifted verbatim into the method's page on docs.payam-resan.com, so it is read by
people who have never seen this repository.

Two consequences:

- **Full-line comments are stripped** when the region is lifted. Anything the
  reader must see has to be code. The `Success` check is a `guard`, not a note.
- The file name matches the reference page slug exactly: `send-bulk.swift`,
  `status-by-user-trace-id.swift`. A path with two variants gets two files, the
  plain name for `POST` and a `-get` suffix for `GET`.

The full contract lives in the `handbook` repository, section `docs-site`, file
`code-samples.md`.

## Rule five: check Success, and check it is there at all

The service answers `200` to everything, including a wrong key and an empty
account, so the HTTP status proves nothing.

One `guard` covers both halves, and the optional cast is the part that matters:

```swift
guard let success = response?["Success"] as? Bool, success else {
    let code = response?["ErrorCode"] as? Int ?? 0
    let message = response?["Error"] as? String ?? ""
    FileHandle.standardError.write(Data("...\(code): \(message)\n".utf8))
    exit(1)
}
```

A URL that does not exist answers with a body carrying only `Message`. The cast
then fails, the guard fires, and the reader gets a message instead of a crash.
That case is real: it is what the sandbox server returns for `TokenList`.

## Rule six: dictionaries, not Codable

Bodies are built as `[String: Any]` and responses are read with
`JSONSerialization`. Codable is the more idiomatic Swift, and it is the right
choice inside a real application, but here it would put twenty lines of type
declarations in front of the four lines that show the API. The README points
readers at the typed version instead.

Numbers go in as numbers. `Sender` is `int64` in the spec, so the value read
from the environment is converted with `Int(...)` and the example exits loudly
if it is not a number.

## Rule seven: a version is a folder

A new service version means a new `examples/v<n>/`. No file inside an existing
version folder is moved or renamed; older versions still have users.

## Secrets

The key comes from `PAYAM_RESAN_API_KEY` in the environment. No key, no real
phone number and no customer name goes into a file here, not even a dead one.
Example numbers are `9121112222` upward and the example key is
`123456-XXXXXXXXXXXXXXX`.

## Layout

| Path | What it holds |
|---|---|
| `examples/v3/` | one self-contained file per service operation |
| `.env.example` | the environment variables the examples read |

## Before every commit

Run each file. A compile-only check is not enough, because the failures that
matter are the runtime ones.

On a machine without a Swift toolchain, the official image is the easiest way:

```bash
#!/bin/sh
# Run every example against the sandbox server.
set -u
export PAYAM_RESAN_API_KEY=123456-XXXXXXXXXXXXXXX
export PAYAM_RESAN_SENDER=30004040
export HOME=/tmp/home
mkdir -p /tmp/home /tmp/sandbox

for file in /src/examples/v3/*.swift; do
    name=$(basename "$file")
    sed 's#/api/V3/#/api/V3SandBox/#' "$file" > "/tmp/sandbox/$name"
    printf '\n===== %s =====\n' "$name"
    swift "/tmp/sandbox/$name" || echo "FAILED $name"
done
```

```bash
docker run --rm -u "$(id -u):$(id -g)" \
    -v "$PWD":/src -v "$PWD/../scripts":/sp:ro \
    swift:6.1 sh /sp/run-swift.sh
```

Passing `-u` keeps anything the run writes owned by you rather than by root.

The `sed` sends everything at `api/V3SandBox/`, so no real message goes out and
no credit is spent. That server answers with fabricated data and ignores the
key, so the example key above is enough to run the whole set. `TokenList` is the
one method it does not implement: it answers `404` there and has to be checked
against the live server instead.

## Git

Semantic messages, `type(scope): subject`, with no explanatory body and no
attribution trailer. Commits here are authored as Payam Resan.
