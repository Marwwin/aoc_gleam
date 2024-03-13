import gleam/string
import gleam/list
import gleam/int
import utils

pub fn part1(input: String) -> String {
  parse_input(input)
  |> list.map(fn(row) {
    let max = list.fold(row, 0, fn(acc, n) { int.max(acc, n) })
    list.fold(row, 0, fn(acc, n) { int.max(acc, max - n) })
  })
  |> utils.sum()
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  parse_input(input)
  |> list.map(fn(row) { find_evenly_divisable(row) })
  |> utils.sum()
  |> int.to_string()
}

fn find_evenly_divisable(list: List(Int)) -> Int {
  let assert [first, ..rest] = list
  list.flat_map(rest, fn(n) {
    case int.max(n, first) % int.min(n, first) {
      0 -> [int.max(n, first) / int.min(n, first)]
      _ -> []
    }
  })
  |> utils.sum()
  |> fn(l) {
    case l {
      0 -> find_evenly_divisable(rest)
      n -> n
    }
  }
}

fn parse_input(input: String) -> List(List(Int)) {
  string.trim(input)
  |> string.split("\n")
  |> list.map(fn(row) {
    string.trim(row)
    |> string.split("\t")
    |> list.map(fn(s) {
      let assert Ok(n) = int.parse(s)
      n
    })
  })
}
