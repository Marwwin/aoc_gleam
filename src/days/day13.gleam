import gleam/string
import gleam/list
import gleam/int
import gleam/result
import gleam/dict

pub fn solution(input: String) {
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(fn(s) {
      string.split(s, ": ")
      |> list.map(int.parse)
      |> result.values
    })
    |> list.fold(dict.new(), fn(acc, e) {
      let assert Ok(key) = list.at(e, 0)
      let assert Ok(depth) = list.at(e, 1)
      dict.insert(acc, key, depth)
    })
  #("Day 13", part1(input), part2(input))
}

pub fn part1(input) {
  walk_part1(input, 0, 0)
  |> int.to_string
}

fn walk_part1(d, time, count) {
  case time {
    99 -> count
    _ -> {
      case dict.get(d, time) {
        Ok(v) -> {
          let score = case time % { { v * 2 } - 2 } {
            0 -> time * v
            _ -> 0
          }
          walk_part1(d, time + 1, count + score)
        }
        Error(_) -> walk_part1(d, time + 1, count)
      }
    }
  }
}

pub fn part2(input) {
  walk_part2(input, 0, 0)
  |> int.to_string
}

fn walk_part2(d, time, offset) {
  case do_walk_part2(d, time, offset) {
    0 -> time
    _ -> walk_part2(d, time + 1, offset + 1)
  }
}

fn do_walk_part2(d, time, offset) {
  case time - offset {
    99 -> 0
    _ -> {
      case dict.get(d, time - offset) {
        Ok(v) -> {
          case time % { { v * 2 } - 2 } {
            0 -> -1
            _ -> do_walk_part2(d, time + 1, offset)
          }
        }
        Error(_) -> do_walk_part2(d, time + 1, offset)
      }
    }
  }
}
