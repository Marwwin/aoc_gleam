import gleam/string
import gleam/list
import gleam/io
import gleam/dict.{type Dict}

pub type Size {
  Size2(in: List(String), out: List(String))
  Size3(in: List(String), out: List(String))
}

pub fn solution(input: String) {
  let sizes =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(parse)
  let rules =
    dict.new()
    |> dict.insert(
      "Size2",
      sizes
        |> list.filter(fn(s) {
          case s {
            Size2(_, _) -> True
            _ -> False
          }
        }),
    )
    |> dict.insert(
      "Size3",
      sizes
        |> list.filter(fn(s) {
          case s {
            Size3(_, _) -> True
            _ -> False
          }
        }),
    )
    |> io.debug
  let start_pattern = [".#.", "..#", "###"]
  #("Day 21", part1(rules, start_pattern), part2())
}

fn part1(rules: Dict(String, List(Size)), pattern: List(String)) {
  ""
}

fn part2() {
  ""
}

fn parse(str) {
  let assert [a, b] =
    str
    |> string.trim
    |> string.split(" => ")

  case string.split(a, "/"), string.split(b, "/") {
    [r1, r2], b -> Size2(in: [r1, r2], out: b)
    [r1, r2, r3], b -> Size3(in: [r1, r2, r3], out: b)
    _, _ -> panic as "unknown input"
  }
}
