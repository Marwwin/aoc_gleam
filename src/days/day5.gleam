import gleam/string
import gleam/int
import gleam/list
import gleam/io
import gleam/result
import gleam/dict

pub fn part1(input: String) {
  parse(input)
  |> walk(0, 0, False)
  |> int.to_string()
}

fn walk(jumps, index, steps, is_part2) {
  let step = dict.get(jumps, index)
  case step {
    Ok(step) -> {
      let d =
        dict.insert(jumps, index, step + { 1 * step_offset(step, is_part2) })
      walk(d, index + step, steps + 1, is_part2)
    }
    Error(_) -> steps
  }
}


pub fn part2(input: String) {
  parse(input)
  |> walk(0, 0, True)
  |> int.to_string()
}

fn step_offset(value, is_part2) {
  case is_part2 {
    False -> 1
    True ->
      case value {
        n if n >= 3 -> -1
        _ -> 1
      }
  }
}

fn parse(input) {
  string.trim(input)
  |> string.split("\n")
  |> list.map(int.parse)
  |> result.values()
  |> list.index_map(fn(x, i) { #(i, x) })
  |> dict.from_list()
}
