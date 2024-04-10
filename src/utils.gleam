import gleam/list
import gleam/int
import gleam/result
import gleam/string

pub type Direction {
  Up
  Left
  Down
  Right
}

pub fn sum(list: List(Int)) -> Int {
  list.fold(list, 0, fn(acc, n) { acc + n })
}

pub fn product(list: List(Int)) -> Int {
  list.fold(list, 1, fn(acc, n) { acc * n })
}

pub fn string_to_int(str) -> List(Int) {
  string.to_utf_codepoints(str)
  |> list.map(string.utf_codepoint_to_int)
}

pub fn hex_to_int(hex: String) -> Int {
  int.base_parse(hex, 16)
  |> result.unwrap(0)
}

pub fn hex_to_bin(hex: Int, bits: Int) -> String {
  hex
  |> int.to_base2
  |> string.pad_left(bits, "0")
}
