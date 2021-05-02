# SCTE35Parser

⚠️ Work in progress ⚠️

SCTE35Parser aims to provide an easy to use, Swift implemented abstraction of SCTE-35 messages, in particular the Splice Info Section type. The [2020 SCTE-25 specification](./Specification/SCTE-35-2020_notice-1609861286512.pdf) was used and is included as part of the repository.

One of the design goals of the abstraction was to make it more "Swifty", in the sense of having the abstraction more type-safe, by eliminating from the public abstraction a lot of the specified information used just for parsing, and translating it instead into more normal Swift concepts, such as optionals, enums, etc. For example, the specification includes many "flags" used to determine if the next section needs to be parsed; in these cases the flag is not publicised and instead the following section is exposed as an `Optional` on the public abstraction.

## Usage
The primary integration point to the framework is the [`SpliceInfoSection`](./Sources/SCTE35Parser/SpliceInfoSection.swift) struct.

Given a base64 encoded SCTE-35 message, the `SpliceInfoSection` offers an `init(base64String: String) throws`.
```swift
let base64String = "/DA0AAAAAAAA///wBQb+cr0AUAAeAhxDVUVJSAAAjn/PAAGlmbAICAAAAAAsoKGKNAIAmsnRfg=="
let spliceInfoSection = try SpliceInfoSection(base64String: base64String)
```

Errors can be thrown if there are some issues with the provided SCTE-35 message that invalidate the parsing. If an error is thrown it will be a [`SCTE35ParserError`](./Sources/SCTE35Parser/Errors/SCTE35ParserError.swift). This is a wrapper `struct` that includes the thrown `error`, as well as the first "non-fatal" error that was stored during parsing. When using the `SCTE35ParserError` as `NSError`, the `underlyingError` will be stored in `userInfo[NSUnderlyingErrorKey]`.

The parser also keeps a storage of `nonFatalErrors`. The idea here is that there may be some inconsistencies in the SCTE-35 message (e.g. mis-match between declared `SpliceCommand` length and parsed length), but the message on the whole is still parsable, and so instead of killing the whole parse by throwing, the error is just logged to the `nonFatalErrors` instead.

There is also an initialiser provided for hex encoded strings `init(hexString: String) throws`, as exampled below.
```swift
let hexString = "0xFC3034000000000000FFFFF00506FE72BD0050001E021C435545494800008E7FCF0001A599B00808000000002CA0A18A3402009AC9D17E"
let spliceInfoSection = try SpliceInfoSection(hexString: hexString)
```

And a convenience `init(_ string: String) throws` is also provided that makes a best effort to determine whether the message is in a base64 or hex encoded format before attempting to parse the message. The check will determine if the string "looks hex" by checking that it has a `0x` prefix, and assuming that attempt to convert to `Data` using hex format first and failing that trying with `Data.init?(base64Encoded base64String: String)` (and vice-versa where the string does not "look hex"). This approach is exampled below.
```swift
let base64String = "/DA0AAAAAAAA///wBQb+cr0AUAAeAhxDVUVJSAAAjn/PAAGlmbAICAAAAAAsoKGKNAIAmsnRfg=="
let hexString = "0xFC3034000000000000FFFFF00506FE72BD0050001E021C435545494800008E7FCF0001A599B00808000000002CA0A18A3402009AC9D17E"
let spliceInfoSectionFromBase64 = try SpliceInfoSection(base64String)
let spliceInfoSectionFromHex = try SpliceInfoSection(hexString)
XCTAssertEqual(spliceInfoSectionFromBase64, spliceInfoSectionFromHex)
```

There is also an `init(data: Data) throws` provided for cases where the input is already converted to `Data`.
```swift
let base64String = "/DA0AAAAAAAA///wBQb+cr0AUAAeAhxDVUVJSAAAjn/PAAGlmbAICAAAAAAsoKGKNAIAmsnRfg=="
let data = Data(base64Encoded: base64String)!
let spliceInfoSection = try SpliceInfoSection(data: data)
```
