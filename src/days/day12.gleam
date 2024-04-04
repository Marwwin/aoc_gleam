import gleam/string
import gleam/int
import gleam/dict.{type Dict}
import gleam/list
import gleam/set.{type Set}

pub fn solution(input: String) -> #(String, String, String) {
  let input =
    input
    |> string.trim
    |> string.split("\n")
    |> list.fold(dict.new(), fn(acc, s) {
      let splitted = string.split(s, " <-> ")
      let assert Ok(key) = list.at(splitted, 0)
      let assert Ok(children) = list.at(splitted, 1)
      let children_list =
        string.split(children, ",")
        |> list.map(string.trim)

      dict.insert(acc, key, children_list)
    })

  #("Day12", part1(input), part2(input))
}

pub fn part1(input: Dict(String, List(String))) -> String {
  input
  |> part1_walk("0")
  |> set.size
  |> int.to_string
}

fn part1_walk(d: Dict(String, List(String)), start) -> Set(String) {
  do_walk(d, [start], set.new())
}

pub fn part2(input: Dict(String, List(String))) -> String {
  let seen = set.new()
  let range =
    list.range(0, 1999)
    |> list.map(int.to_string)
  part2_walk(input, range, seen, 0)
  |> int.to_string
}

fn part2_walk(d, range: List(String), seen: Set(String), count: Int) -> Int {
  case range {
    [e, ..rest] -> {
      case set.contains(seen, e) {
        True -> part2_walk(d, rest, seen, count)
        False -> {
          let stack = [e]
          let res = do_walk(d, stack, seen)
          part2_walk(d, rest, res, count + 1)
        }
      }
    }
    [] -> count
  }
}

fn do_walk(
  d: Dict(String, List(String)),
  stack: List(String),
  seen: Set(String),
) -> Set(String) {
  case stack {
    [key, ..rest] -> {
      case dict.get(d, key) {
        Ok(children) -> {
          let pushed = push_to_stack(rest, children, seen)
          do_walk(d, pushed.0, pushed.1)
        }
        Error(_) -> panic as "Not found in d"
      }
    }
    [] -> seen
  }
}

fn push_to_stack(
  stack: List(String),
  children: List(String),
  seen: Set(String),
) -> #(List(String), Set(String)) {
  case children {
    [a, ..rest] -> {
      case set.contains(seen, a) {
        True -> push_to_stack(stack, rest, seen)
        False -> push_to_stack([a, ..stack], rest, set.insert(seen, a))
      }
    }
    [] -> #(stack, seen)
  }
}
