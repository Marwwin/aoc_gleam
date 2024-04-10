import gleam/result
import gleam/dict.{type Dict}
import gleam/set.{type Set}
import gleam/int
import gleam/io
import gleam/string
import gleam/list
import utils
import point.{type Point, Point}
import grid.{type Grid, Grid}
import days/day10.{knothash}

const row_size = 128

pub fn solution(input: String) {
  let input =
    list.range(0, 127)
    |> list.map(fn(i) {
      knothash(string.trim(input) <> "-" <> int.to_string(i))
      |> string.split("")
      |> list.map(hex_to_4_bit)
      |> string.join("")
    })

  #("Day14", part1(input), part2(input))
}

pub fn part1(input) {
  input
  |> list.fold(0, fn(acc, hash) { acc + count_ones(hash) })
  |> int.to_string
}

fn hex_to_4_bit(hex: String) -> String {
  hex
  |> utils.hex_to_int
  |> utils.hex_to_bin(4)
}

fn count_ones(binary: String) {
  let digits = string.split(binary, "")
  list.fold(digits, 0, fn(acc, digit) {
    case digit {
      "1" -> acc + 1
      _ -> acc
    }
  })
}

pub fn part2(input: List(String)) {
  let grid =
    list.fold_right(input, [], fn(acc, row) { [row, ..acc] })
    |> string.join("")
    |> string.split("")
    |> grid.from_list(_,128)

  let seen = set.new()
  walk(grid, 0, seen, 0)
  |> io.debug

  io.debug(dict.size(grid.grid))
  ""
}

fn walk(grid, i, seen, n_regions) {
  let point = grid.index_to_point(grid, i)
  io.debug(point)
  case set.contains(seen, point) {
    True -> walk(grid, i + 1, seen, n_regions)
    False ->
      case grid.at(grid, point) {
        Ok("1") -> {
          let new_seen = walk_region(grid, point, set.insert(seen, point))
          walk(grid, i + 1, new_seen, n_regions + 1)
        }
        Ok("0") -> {
          walk(grid, i + 1, set.insert(seen, point), n_regions)
        }
        Error(_) -> n_regions
        _ -> panic("should not happen")
      }
  }
}

fn walk_region(grid, point, seen) {
  do_walk_region(grid, [point], seen)
}

fn do_walk_region(grid, stack, seen: Set(Point)) {
  case stack {
    [] -> seen
    [p, ..rest] -> {
      let neighbours =
        grid.adjacent(grid, p)
        |> list.filter(fn(point) { point.1 == "1" })
      let new_stack_seen = add_neighbours_to_stack(neighbours, rest, seen)
      do_walk_region(grid, new_stack_seen.0, new_stack_seen.1)
    }
  }
}

fn add_neighbours_to_stack(
  neighbours: List(#(Point, String)),
  stack: List(Point),
  seen,
) {
  case neighbours {
    [] -> #(stack, seen)
    [#(p, _), ..rest] -> {
      case set.contains(seen, p) {
        True -> add_neighbours_to_stack(rest, stack, seen)
        False -> {
          add_neighbours_to_stack(rest, [p, ..stack], set.insert(seen, p))
        }
      }
    }
  }
}
