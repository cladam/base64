// Tests for base64 encode/decode
import "../src/base64"

test "encode empty string" {
  assert(b64_encode("") == "")
}

test "encode single character" {
  assert(b64_encode("f") == "Zg==")
}

test "encode two characters" {
  assert(b64_encode("fo") == "Zm8=")
}

test "encode three characters" {
  assert(b64_encode("foo") == "Zm9v")
}

test "encode Hello, World!" {
  assert(b64_encode("Hello, World!") == "SGVsbG8sIFdvcmxkIQ==")
}

test "encode longer string" {
  assert(b64_encode("The quick brown fox") == "VGhlIHF1aWNrIGJyb3duIGZveA==")
}

test "decode empty string" {
  assert(b64_decode("") == Ok(""))
}

test "decode single char padding" {
  assert(b64_decode("Zm9v") == Ok("foo"))
}

test "decode with padding" {
  assert(b64_decode("SGVsbG8sIFdvcmxkIQ==") == Ok("Hello, World!"))
}

test "decode invalid character" {
  let result = b64_decode("!!!!")
  match result {
    Err(_) => assert(true),
    Ok(_) => assert(false)
  }
}

test "roundtrip" {
  let original = "base64 is fun"
  let encoded = b64_encode(original)
  assert(b64_decode(encoded) == Ok(original))
}

test "url-safe encode" {
  // URL-safe uses - and _ instead of + and /
  // and no padding
  let encoded = b64_encode_url("Hello, World!")
  assert(str_contains(encoded, "+") == false)
  assert(str_contains(encoded, "/") == false)
  assert(str_contains(encoded, "=") == false)
}

// --- UTF-8 tests ---

test "encode UTF-8 2-byte" {
  assert(b64_encode("é") == "w6k=")
}

test "encode UTF-8 3-byte" {
  assert(b64_encode("日") == "5pel")
}

test "encode UTF-8 mixed" {
  assert(b64_encode("héllo") == "aMOpbGxv")
}

test "roundtrip UTF-8" {
  let original = "héllo"
  let encoded = b64_encode(original)
  assert(b64_decode(encoded) == Ok(original))
}

test "roundtrip UTF-8 3-byte" {
  let original = "日本語"
  let encoded = b64_encode(original)
  assert(b64_decode(encoded) == Ok(original))
}

// --- URL-safe decode tests ---

test "url-safe decode" {
  assert(b64_decode_url("Pj4-") == Ok(">>>"))
}

test "url-safe roundtrip" {
  let original = ">>>"
  let encoded = b64_encode_url(original)
  assert(b64_decode_url(encoded) == Ok(original))
}

// --- Validation tests ---

test "decode invalid length" {
  let result = b64_decode("A")
  match result {
    Err(_) => assert(true),
    Ok(_) => assert(false)
  }
}
