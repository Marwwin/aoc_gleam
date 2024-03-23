import gleam/string
import gleam/result
import gleam/list
import gleam/io
import gleam/int
import gleam/pair

pub fn solution(input: String) {
  let grid =
    input
    |> string.trim
    |> string.split(",")
  #("Day 11", part1(grid), part2())
}

pub fn part1(input: List(String)) {
  input
  |> list.fold(#(0, 0), fn(acc, x) {
    case x {
      "n" -> #(acc.0, acc.1 + 2)
      "ne" -> #(acc.0 + 1, acc.1 + 1)
      "se" -> #(acc.0 + 1, acc.1 - 1)
      "s" -> #(acc.0, acc.1 - 2)
      "sw" -> #(acc.0 - 1, acc.1 - 1)
      "nw" -> #(acc.0 - 1, acc.1 + 1)
      _ -> panic as "wrong input"
    }
  })
  |> pair.map_second(fn(n) {
    let assert r = result.unwrap(int.divide(n, 2),0)
    r
  })
  |> io.debug
  |> format
  |> int.to_string
  
}

fn format(t: #(Int, Int)) {
  int.absolute_value(t.0) + int.absolute_value(t.1)
}

pub fn part2() {
  ""
}
