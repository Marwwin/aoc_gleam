import gleam/io
import gleam/int
import matrix
import point.{type Point, Point}
import direction.{type Direction}
import utils

pub fn part1(input: Int) -> String {
  let level = get_level(input)
  let diff = get_value_at_level(level) - input
  let p = Point(level - diff, level)
  point.manhattan(p, Point(0, 0))
  |> int.to_string()
}

pub fn part2(input: Int) -> String {
  let m =
    matrix.new()
    |> matrix.insert(Point(0, 0), 1)
  walk_matrix(m, input, Point(0, 0), direction.Right, 0)
  |> int.to_string()
}

fn walk_matrix(m, goal, previous: Point, dir: Direction, level) {
  let assert Ok(v) = matrix.get(m, previous)
  case v > goal {
    True -> v
    False -> {
      let next_dir = get_next_direction(previous, dir, level, matrix.size(m))
      let next_pos = point.move(previous, next_dir)
      let next_level = get_next_level(level, matrix.size(m))
      let sum =
        matrix.neighbours(m, next_pos)
        |> utils.sum()

      io.debug(next_pos)
      io.debug(level)
      io.debug(next_dir)
      walk_matrix(
        matrix.insert(m, next_pos, sum),
        goal,
        next_pos,
        next_dir,
        next_level,
      )
    }
  }
}

fn get_next_direction(
  current: Point,
  direction: Direction,
  level: Int,
  size: Int,
) -> Direction {
  let max = get_value_at_level(level)
  case level {
    0 -> direction.Right
    _ if size == max -> {
      direction.Right
    }
    _ if size == max  -> direction.Up
    _ ->
      case is_at_end_of_row(current, direction, level) {
        True ->
          case direction {
            direction.Left -> direction.Down
            direction.Down -> direction.Right
            direction.Right -> direction.Up
            direction.Up -> direction.Left
          }
        False -> direction
      }
  }
}

fn is_at_end_of_row(current: Point, direction: Direction, level: Int) -> Bool {
  let row_edge =
    get_side_at_level(level)
    |> fn(side_length) { side_length - 1 / 2 }

  case direction {
    direction.Right -> current.x >= row_edge
    direction.Left -> current.x <= -row_edge
    direction.Up -> current.y >= row_edge
    direction.Down -> current.y <= -row_edge
  }
}

pub fn get_level(n: Int) -> Int {
  get_level_helper(n, 1, 0)
}

fn get_level_helper(goal: Int, val: Int, level: Int) {
  let x = val + 8 * level
  case x {
    n if n >= goal -> level
    n -> get_level_helper(goal, n, level + 1)
  }
}

pub fn get_value_at_level(level: Int) -> Int {
  get_value_at_level_helper(level, 1)
}

fn get_value_at_level_helper(level: Int, sum: Int) -> Int {
  case level {
    0 -> sum
    n -> get_value_at_level_helper(n + -1, sum + 8 * level)
  }
}

fn get_next_level(level, size) {
  let max = get_value_at_level(level)
  case size {
    n if n >= max -> level + 1
    _ -> level
  }
}

pub fn get_side_at_level(level: Int) -> Int {
  1 + 2 * { level - 1 }
}
