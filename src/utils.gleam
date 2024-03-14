import gleam/list
import gleam/string
import gleam/int

pub type Direction {
  Up
  Left
  Down
  Right
}

pub fn sum(list: List(Int)) {
  list.fold(list, 0, fn(acc, n) { acc + n })
}

pub fn string_to_int(str) {
  string.to_utf_codepoints(str)
  |> list.map(string.utf_codepoint_to_int)
}
