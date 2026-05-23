# base64

Base64 encoding and decoding library for [hica](https://cladam.github.io/hica).

Pure functions, no effects — a showcase of hica's functional style.

Full UTF-8 support: correctly encodes and decodes multi-byte characters.

## Installation

Add as a git submodule to your hica project:

```sh
git submodule add https://github.com/cladam/base64.git lib/base64
```

Then import the library:

```rust
import "./lib/base64/src/base64"
```
## Usage

```rust
fun main() {
  let encoded = b64_encode("Hello, World!")
  println(encoded)  // SGVsbG8sIFdvcmxkIQ==

  match b64_decode(encoded) {
    Ok(text) => println(text),  // Hello, World!
    Err(e) => println("Error: " + e)
  }
}
```

## API

### Encoding

| Function | Description |
|---|---|
| `b64_encode(input: string) : string` | Encode to standard base64 (RFC 4648) with padding |
| `b64_encode_url(input: string) : string` | Encode to URL-safe base64 (no padding) |

### Decoding

| Function | Description |
|---|---|
| `b64_decode(input: string) : result<string, string>` | Decode standard base64 |
| `b64_decode_url(input: string) : result<string, string>` | Decode URL-safe base64 |

Decoding returns `Ok(decoded_string)` on success or `Err(message)` on invalid input (bad characters or invalid length).

## Project Structure

```sh
src/
  base64.hc    # barrel module (pub imports)
  types.hc     # alphabet constants + UTF-8 byte conversion
  encode.hc    # encoding functions
  decode.hc    # decoding functions
tests/
  test-base64.hc
examples/
  basic.hc
```

## Development

```sh
hica run examples/basic.hc   # run the example
hica test tests/test-base64.hc  # run tests
hica check src/base64.hc     # type-check
```

## License

MIT
