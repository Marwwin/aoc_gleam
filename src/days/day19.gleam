import direction.{type Direction, Down, Left, Right, Up}
import point.{type Point, Point}
import gleam/io
import gleam/list
import gleam/int
import gleam/result
import gleam/string

pub fn solution(input: String) {
  let map =
    string.split(input, "\n")
    |> list.map(fn(row) { string.split(row, "") })

  let assert Ok(first) = list.first(map)
  let start_pos = Point(find_start(first), 0)

  let result = walk(map, start_pos, Down, "", 1)
  #("Day 19", result.0, int.to_string(result.1))
}

fn walk(map, pos: Point, dir, result, i) {
  case map_at(map, pos) {
    "|" -> walk(map, point.inverted_move(pos, dir), dir, result, i + 1)
    "-" -> walk(map, point.inverted_move(pos, dir), dir, result, i + 1)
    " " -> panic as "oops"
    "+" -> {
      let next_dir = map_neighbours(map, pos, dir)
      walk(map, point.inverted_move(pos, next_dir), next_dir, result, i + 1)
    }
    "S" -> #(result <> "S", i)
    ch -> walk(map, point.inverted_move(pos, dir), dir, result <> ch, i + 1)
  }
}

fn map_at(map, point: Point) {
  let Point(x, y) = point
  list.at(map, y)
  |> result.unwrap([])
  |> list.at(x)
  |> result.unwrap(" ")
}

fn map_neighbours(map, pos: Point, dir: Direction) {
  let res =
    [Left, Right, Up, Down]
    |> list.filter(fn(d) { d != direction.opposite(dir) })
    |> list.filter(fn(d) {
      let neighbour =
        point.inverted_move(pos, d)
        |> map_at(map, _)
      case neighbour {
        "-" ->
          case d {
            Left | Right -> True
            _ -> False
          }
        "|" ->
          case d {
            Up | Down -> True
            _ -> False
          }
        _ -> False
      }
    })

  case res {
    [a] -> a
    [_, _, .._] -> panic as "Too much"
    _ -> panic as "too little"
  }
}

fn find_start(row: List(String)) {
  do_find_start(row, 0)
}

fn do_find_start(row: List(String), i) {
  case row {
    ["|", ..] -> i
    [_, ..rest] -> do_find_start(rest, i + 1)
    _ -> panic as "should not"
  }
}

