import gleam/string
import gleam/io
import gleam/int
import gleam/list

pub fn part1(input: String) {
  string.trim(input)
  |> string.split("\n")
  |> list.flat_map(fn(row) {
    let l = string.split(row, " ")
    case list.length(l) == list.length(list.unique(l)) {
      True -> [row]
      False -> []
    }
  })
  |> list.length()
  |> int.to_string()
}

pub fn part2(input: String) {
  string.trim(input)
  |> string.split("\n")
  |> list.flat_map(fn(row) {
    let l =
      string.split(row, " ")
      |> list.sort(fn(a, b) { lstring.to_utf_codepoints(a) < string.to_utf_codepoints(b) })
    case list.length(l) == list.length(list.unique(l)) {
      True -> [row]
      False -> []
    }
  })
  |> list.length()
  |> int.to_string()
}
