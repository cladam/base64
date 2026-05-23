// base64/types — shared types and utilities for base64 encoding/decoding

// Base64 alphabet: standard (RFC 4648) with + and /
// Index 0–63 maps to A–Z, a–z, 0–9, +, /
pub fun b64_alphabet() => "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

// Padding character
pub fun b64_pad() => '='

// URL-safe alphabet: replaces + with - and / with _
pub fun b64_url_alphabet() => "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

// --- UTF-8 byte conversion ---

// Convert a character to its UTF-8 byte values
pub fun char_to_utf8(c: char) {
  let cp = ord(c)
  if cp < 128 { [cp] }
  else if cp < 2048 { [192 + cp / 64, 128 + cp % 64] }
  else if cp < 65536 { [224 + cp / 4096, 128 + (cp / 64) % 64, 128 + cp % 64] }
  else { [240 + cp / 262144, 128 + (cp / 4096) % 64, 128 + (cp / 64) % 64, 128 + cp % 64] }
}

// Convert a string to UTF-8 bytes
pub fun str_to_bytes(s: string) =>
  concat(map(chars(s), (c) => char_to_utf8(c)))

// Decode a 2-byte UTF-8 sequence to a codepoint
pub fun utf8_2(b0: int, b1: int) =>
  (b0 - 192) * 64 + (b1 - 128)

// Decode a 3-byte UTF-8 sequence to a codepoint
pub fun utf8_3(b0: int, b1: int, b2: int) =>
  (b0 - 224) * 4096 + (b1 - 128) * 64 + (b2 - 128)

// Decode a 4-byte UTF-8 sequence to a codepoint
pub fun utf8_4(b0: int, b1: int, b2: int, b3: int) =>
  (b0 - 240) * 262144 + (b1 - 128) * 4096 + (b2 - 128) * 64 + (b3 - 128)

// Convert UTF-8 bytes back to a string
pub fun bytes_to_str(bs: list<int>) =>
  match bs {
    [] => "",
    [b, ..rest] if b < 128 =>
      from_chars([chr(b)]) + bytes_to_str(rest),
    [b0, b1, ..rest] if b0 < 224 =>
      from_chars([chr(utf8_2(b0, b1))]) + bytes_to_str(rest),
    [b0, b1, b2, ..rest] if b0 < 240 =>
      from_chars([chr(utf8_3(b0, b1, b2))]) + bytes_to_str(rest),
    [b0, b1, b2, b3, ..rest] =>
      from_chars([chr(utf8_4(b0, b1, b2, b3))]) + bytes_to_str(rest),
    _ => ""
  }
