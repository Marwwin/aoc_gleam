import gleam/string
import gleam/int

pub type DirCounter {
  DirCounter(nw: Int, ew: Int, ewoffset: Int)
}

pub fn solution(input: String) {
  let result =
    input
    |> string.trim
    |> string.split(",")
    |> walk(#(0, 0, 0), 0)
  #("Day 11", int.to_string(result.0), int.to_string(result.1))
}

fn walk(input: List(String), counter: #(Int, Int, Int), max: Int) {
  case input, counter {
    ["n", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y + 1, x, ysxs)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    ["s", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y - 1, x, ysxs)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    ["ne", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y, x + 1, ysxs + 1)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    ["nw", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y, x - 1, ysxs + 1)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    ["se", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y, x + 1, ysxs - 1)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    ["sw", ..rest], #(y, x, ysxs) -> {
      let new_counter = #(y, x - 1, ysxs - 1)
      walk(rest, new_counter, int.max(max, calc_distance(new_counter)))
    }
    [], _ -> #(calc_distance(counter), max)
    _, _ -> panic as "Marwin"
  }
}

fn calc_distance(counter: #(Int, Int, Int)) {
  let #(y, x, ysxs) = counter
  int.absolute_value(y)
  + int.absolute_value(x)
  + { { int.absolute_value(ysxs) - int.absolute_value(x) } / 2 }
}

// This was my first solution to part1 but it is now commented out since the walk function calculates both part1 and part2
//pub fn part1(input: List(String)) {
//  let d =
//    input
//    |> list.group(fn(key) { key })
//    |> dict.map_values(fn(_, value) { list.length(value) })
//
//  let up_down =
//    d
//    |> dict.take(["n", "s"])
//    |> dict.fold(0, fn(acc, key, value) {
//      case key {
//        "n" -> acc + value
//        "s" -> acc - value
//        _ -> panic as "hmm"
//      }
//    })
//    |> int.absolute_value
//
//  let left_right =
//    d
//    |> dict.take(["ne", "se", "nw", "sw"])
//    |> dict.fold(0, fn(acc, key, value) {
//      case key {
//        "ne" -> acc + value
//        "se" -> acc + value
//        "nw" -> acc - value
//        "sw" -> acc - value
//        _ -> panic as "hmm"
//      }
//    })
//    |> int.absolute_value
//
//  let left_right_up_down =
//    d
//    |> dict.take(["ne", "se", "nw", "sw"])
//    |> dict.fold(0, fn(acc, key, value) {
//      case key {
//        "ne" -> acc + value
//        "se" -> acc - value
//        "nw" -> acc + value
//        "sw" -> acc - value
//        _ -> panic as "hmm"
//      }
//    })
//    |> int.absolute_value
//
//  calc_distance(#(up_down, left_right, left_right_up_down))
//  |> int.to_string
//}
//
//pub fn part2(grid) {
//  walk(grid, #(0, 0, 0), 0)
//}
