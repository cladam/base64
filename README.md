# base64

Base64 encoding and decoding library for [hica](https://cladam.github.io/hica).

Pure functions, no effects. A showcase of hica's functional style.

Full UTF-8 support: correctly encodes and decodes multi-byte characters.

## Installation

### 1. Add the package

```sh
hica add base64
hica fetch
```

This records the dependency in `hica.hml` and downloads the package into `vendor/`.

### 2. Import

```hica
import "base64"
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

## Development

```sh
hica run examples/basic.hc   # run the example
hica test tests/test-base64.hc  # run tests
hica check src/base64.hc     # type-check
```

## License

MIT
