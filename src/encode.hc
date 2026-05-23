// base64/encode — encode a string to base64
import "types"

// Encode a string to standard base64 (RFC 4648)
pub fun b64_encode(input: string) : string =>
  encode_with(input, b64_alphabet(), true)

// Encode a string to URL-safe base64 (no padding)
pub fun b64_encode_url(input: string) : string =>
  encode_with(input, b64_url_alphabet(), false)

// Encode using a given alphabet, with optional padding
pub fun encode_with(input: string, alphabet: string, pad: bool) : string {
  let bytes = str_to_bytes(input)
  let encoded = encode_bytes(bytes, alphabet)
  if pad { add_padding(encoded) }
  else { encoded }
}

// Process bytes in groups of 3
pub fun encode_bytes(bs: list<int>, alphabet: string) : string =>
  match bs {
    [] => "",
    [a] => {
      let i0 = a / 4
      let i1 = (a % 4) * 16
      let c0 = alphabet[i0:i0 + 1]
      let c1 = alphabet[i1:i1 + 1]
      c0 + c1
    },
    [a, b] => {
      let i0 = a / 4
      let i1 = (a % 4) * 16 + b / 16
      let i2 = (b % 16) * 4
      let c0 = alphabet[i0:i0 + 1]
      let c1 = alphabet[i1:i1 + 1]
      let c2 = alphabet[i2:i2 + 1]
      c0 + c1 + c2
    },
    [a, b, c, ..rest] => {
      let i0 = a / 4
      let i1 = (a % 4) * 16 + b / 16
      let i2 = (b % 16) * 4 + c / 64
      let i3 = c % 64
      let c0 = alphabet[i0:i0 + 1]
      let c1 = alphabet[i1:i1 + 1]
      let c2 = alphabet[i2:i2 + 1]
      let c3 = alphabet[i3:i3 + 1]
      c0 + c1 + c2 + c3 + encode_bytes(rest, alphabet)
    }
  }

// Add = padding to make length a multiple of 4
pub fun add_padding(s: string) : string {
  let remainder = str_length(s) % 4
  if remainder == 0 { s }
  else if remainder == 2 { s + "==" }
  else if remainder == 3 { s + "=" }
  else { s }
}
