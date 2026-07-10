// base64/decode — decode a base64 string back to plain text
import "types"

// Decode a standard base64 string (RFC 4648)
pub fun b64_decode(input: string) : result<string, string> =>
  decode_with(input, b64_alphabet())

// Decode a URL-safe base64 string
pub fun b64_decode_url(input: string) : result<string, string> =>
  decode_with(input, b64_url_alphabet())

// Decode using a given alphabet
pub fun decode_with(input: string, alphabet: string) : result<string, string> {
  let cleaned = strip_padding(input)
  let indices = map(chars(cleaned), (c) => char_index(c, alphabet))
  if any(indices, (m) => is_none(m)) { Err("invalid base64 character") }
  else if length(indices) % 4 == 1 { Err("invalid base64 length") }
  else { Ok(bytes_to_str(decode_to_bytes(map(indices, (m) => unwrap_maybe_or(m, 0))))) }
}

// Find character position in alphabet, None if not found
pub fun char_index(c: char, alphabet: string) : maybe<int> =>
  index_of(alphabet, char_to_string(c))

// Strip = padding
pub fun strip_padding(s: string) : string {
  let cs = chars(s)
  let filtered = filter(cs, (c) => c != b64_pad())
  from_chars(filtered)
}

// Decode groups of 4 indices to byte values
pub fun decode_to_bytes(indices: list<int>) =>
  match indices {
    [] => [],
    [a, b] => [a * 4 + b / 16],
    [a, b, c] => [a * 4 + b / 16, (b % 16) * 16 + c / 4],
    [a, b, c, d, ..rest] => {
      let byte0 = a * 4 + b / 16
      let byte1 = (b % 16) * 16 + c / 4
      let byte2 = (c % 4) * 64 + d
      [byte0, byte1, byte2] + decode_to_bytes(rest)
    },
    _ => []
  }
