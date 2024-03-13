import gleam/string
import gleam/int
import gleam/result
import gleam/list
import gleam/io

pub fn part1(input: String) -> String {
  let assert Ok(last) = string.first(input)
  string.trim(input)
  |> string.append(last)
  |> string.split("")
  |> list.map(fn(e) {
    let assert Ok(n) = int.parse(e)
    n
  })
  |> part1_helper(0)
  |> int.to_string()
}

fn part1_helper(input: List(Int), sum: Int) -> Int {
  case input {
    [first, second, ..rest] if first == second ->
      part1_helper([second, ..rest], sum + first)
    [_, ..rest] -> part1_helper(rest, sum)
    [] -> sum
  }
}

pub fn part2(input: String) -> String {
  let ints =
    string.trim(input)
    |> string.split("")
    |> list.map(fn(e) {
      let assert Ok(n) = int.parse(e)
      n
    })
    |> list.split(result.unwrap(int.divide(string.length(input), 2), 0))

  list.map2(ints.0, ints.1, fn(a, b) {
    case a == b {
      True -> a + b
      False -> 0
    }
  })
  |> list.fold(0, fn(acc, n) { acc + n })
  |> int.to_string()
}
