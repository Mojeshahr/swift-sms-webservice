<div align="center">

<a href="https://payam-resan.com">
  <img src=".github/assets/logo.svg" width="64" height="64" alt="Payam Resan">
</a>

<h1>Swift examples for the Payam Resan SMS web service</h1>

Talk to the <a href="https://payam-resan.com"><b>Payam Resan SMS panel</b></a> from Swift<br>
One runnable file per API method, with no dependencies

[![API](https://img.shields.io/badge/API-V3-0a7cbd)](https://payam-resan.com)
[![Swift](https://img.shields.io/badge/Swift-6.1-f05138)](https://swift.org)
[![Dependencies](https://img.shields.io/badge/dependencies-none-2ea44f)](#quick-start)
[![License](https://img.shields.io/badge/license-MIT-6e7781)](LICENSE)

<a href="README.md">فارسی</a> · <b>English</b>

</div>

<sub>Looking for another language? The same examples exist for the others at
[github.com/Mojeshahr](https://github.com/Mojeshahr).</sub>

---

## Quick start

```bash
git clone https://github.com/Mojeshahr/swift-sms-webservice.git
cd swift-sms-webservice

export PAYAM_RESAN_API_KEY='123456-XXXXXXXXXXXXXXX'
export PAYAM_RESAN_SENDER='30004040'

swift examples/v3/account-info.swift
```

No package is needed and there is no `Package.swift` here. Each example uses
only `URLSession` and `JSONSerialization`, both part of Foundation, and runs
directly under `swift`.

Start with `account-info.swift`. It sends nothing, spends no credit, and if it
answers then both the key and the connection are fine.

## Before sending anything real

There is a sandbox server that answers exactly like production but sends no
message and spends no credit. Swap `V3` for `V3SandBox` in the URL. The one
exception is `TokenList`, which the sandbox does not implement.

## The methods

| Example | Method | What it does |
|---|---|---|
| [account-info.swift](examples/v3/account-info.swift) | `AccountInfo` | Credit and active lines |
| [send.swift](examples/v3/send.swift) | `Send` | Simple send over `GET` |
| [send-bulk.swift](examples/v3/send-bulk.swift) | `SendBulk` | One text to many recipients, with tracking ids |
| [send-multiple.swift](examples/v3/send-multiple.swift) | `SendMultiple` | A separate text per recipient |
| [token-list.swift](examples/v3/token-list.swift) | `TokenList` | The account's templates |
| [send-token-single.swift](examples/v3/send-token-single.swift) | `SendTokenSingle` | Send a template to one number |
| [send-token-single-get.swift](examples/v3/send-token-single-get.swift) | `SendTokenSingle` | The same, over `GET` |
| [send-token-multi.swift](examples/v3/send-token-multi.swift) | `SendTokenMulti` | One template, many recipients |
| [status-by-id.swift](examples/v3/status-by-id.swift) | `StatusById` | Status by the service's id |
| [status-by-user-trace-id.swift](examples/v3/status-by-user-trace-id.swift) | `StatusByUserTraceId` | Status by your own id |
| [get-inbox.swift](examples/v3/get-inbox.swift) | `GetInbox` | Messages people sent to your lines |

## On Linux

These are tested on Linux too, and that is where the three lines at the top of
every file earn their place:

```swift
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
```

On Apple platforms `URLSession` is part of Foundation. On Linux it lives in a
separate module, so without those lines the code does not compile there. The
`#if` makes it a no-op on macOS and iOS, so one file works in both places.
Leave it in.

## Using this in your own project

Every example is deliberately free of any dependency on this repository, so
copying the body into your own service is enough. If you would rather work with
real types than with dictionaries, change only the response-reading part; the
request shape is the same:

```swift
struct SendResult: Decodable {
    let Id: Int
    let UserTraceId: Int?
}

struct SendResponse: Decodable {
    let Success: Bool
    let ErrorCode: Int?
    let Error: String?
    let Result: [SendResult]?
}

let response = try JSONDecoder().decode(SendResponse.self, from: data)
```

The examples themselves do not, because twenty lines of type declarations would
sit in front of the four that show the API.

An installable SwiftPM package is planned and will be published in its own
repository.

## Things that will save you time

**The HTTP status proves nothing here.** The service answers `200` to
everything, including a wrong key. Decide on the `Success` field.

**Check that the field is there, not just what it holds.** That is what the
`as? Bool` is for: a URL that does not exist answers with a body carrying only
`Message`, and without the cast the code crashes instead of reporting the
error.

**Keep the two kinds of failure apart.** A timeout or a DNS failure lands in
`catch`; the service answering `Success: false` is a different thing. Every
example here reports them separately.

**Recipient numbers carry no leading zero.** Use `9121112222`, or
`989121112222` with the country code. A number that does not start with `9` or
`989` returns error code `13`.

**Do not encode the text twice.** `URLComponents` already does it once. Encode
beforehand as well and the message arrives full of `%D8`.

**Send a unique `UserTraceId` per recipient.** After a timeout it is the only
way to learn whether the message was registered.

## Key safety

The key is a secret. It does not belong in a code repository, in browser
JavaScript, or in a mobile app bundle. It belongs in an environment variable,
which is where every example here reads it from.

If a key leaks, issue a new one from the panel. A deleted key never comes back.

## Layout

| Path | What it holds |
|---|---|
| `examples/v3/` | One self-contained example per service operation |
| `.env.example` | The environment variables the examples read |

The `v3` in the path is deliberate. A new service version means a new
`examples/v<n>/`, with the existing folder left alone.

## Documentation and support

The full guide is at [docs.payam-resan.com](https://docs.payam-resan.com). The
machine-readable OpenAPI description is in
[sms-webservice-spec](https://github.com/Mojeshahr/sms-webservice-spec).

## License

MIT. Full text in [`LICENSE`](LICENSE).
