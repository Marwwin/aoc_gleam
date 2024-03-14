import gleam/string
import gleam/io
import gleam/int
import gleam/list
import utils

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
    let row_int =
      string.split(row, " ")
      |> list.map(fn(word) {
        utils.string_to_int(word)
        |> list.sort(int.compare)
      })
    case list.length(row_int) == list.length(list.unique(row_int)) {
      True -> [row]
      False -> []
    }
  })
  |> list.length()
  |> int.to_string()
}
