import gleam/int
import matrix
import point.{type Point, Point}
import direction.{type Direction, Down, Left, Right, Up}
import utils

pub fn part1(input: Int) -> String {
  let level = get_level(input)
  let diff = get_value_at_level(level) - input
  let p = Point(level - diff, level)
  point.manhattan(p, Point(0, 0))
  |> int.to_string()
}

pub fn part2(input: Int) -> String {
  matrix.new()
  |> matrix.insert(Point(0, 0), 1)
  |> walk_matrix(input, Point(0, 0), Right, 0)
  |> int.to_string()
}

fn walk_matrix(m, goal, previous: Point, dir: Direction, level) {
  let assert Ok(value) = matrix.get(m, previous)
  case value > goal {
    True -> value
    False -> {
      let next_dir = get_next_direction(previous, dir, level, matrix.size(m))
      let next_pos = point.move(previous, next_dir)
      let sum =
        matrix.neighbours(m, next_pos)
        |> utils.sum()

      walk_matrix(
        matrix.insert(m, next_pos, sum),
        goal,
        next_pos,
        next_dir,
        get_next_level(level, matrix.size(m)),
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
  case level {
    0 -> Right
    _ -> {
      let level_max = get_value_at_level(level)
      let first_of_new_level = get_value_at_level(level - 1) + 1
      case level {
        _ if size == level_max -> Right
        _ if size == first_of_new_level -> Up
        _ ->
          case is_at_end_of_row(current, direction, level) {
            True ->
              case direction {
                Left -> Down
                Down -> Right
                Right -> Up
                Up -> Left
              }
            False -> direction
          }
      }
    }
  }
}

fn is_at_end_of_row(current: Point, direction: Direction, level: Int) -> Bool {
  case direction {
    Right -> current.x >= level
    Left -> current.x <= -level
    Up -> current.y >= level
    Down -> current.y <= -level
  }
}

pub fn get_level(n: Int) -> Int {
  get_level_helper(n, 1, 0)
}

fn get_level_helper(goal: Int, val: Int, level: Int) {
  case { val + 8 * level } {
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
