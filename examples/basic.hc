// Example: base64 encoding and decoding
import "../src/base64"

fun main() {
  // Encode
  let encoded = b64_encode("Hello, World!")
  println("Encoded: " + encoded)

  // Decode
  let decoded = b64_decode(encoded)
  match decoded {
    Ok(text) => println("Decoded: " + text),
    Err(e) => println("Error: " + e)
  }

  // URL-safe encoding (no padding)
  let url_encoded = b64_encode_url("Hello, World!")
  println("URL-safe: " + url_encoded)

  // Roundtrip
  let original = "The quick brown fox jumps over the lazy dog"
  let rt = b64_encode(original)
  println("Roundtrip encoded: " + rt)
  match b64_decode(rt) {
    Ok(text) => println("Roundtrip decoded: " + text),
    Err(e) => println("Error: " + e)
  }

  // UTF-8 support
  let utf8 = b64_encode("café ☕")
  println("UTF-8 encoded: " + utf8)
  match b64_decode(utf8) {
    Ok(text) => println("UTF-8 decoded: " + text),
    Err(e) => println("Error: " + e)
  }
}
