import gleam/string
import gleam/int
import gleam/dict.{type Dict}
import point.{type Point, Point}
import direction.{type Direction}

pub type Virus {
  Virus(node: Point, direction: Direction)
}

pub type Node {
  Infected
  Clean
  Weakened
  Flagged
}

type Grid =
  Dict(Point, Node)

pub fn solution(input: String) {
  let grid =
    input
    |> string.trim
    |> string.split("")
    |> parse

  #("Day 22", part1(grid), part2(grid))
}

fn part1(grid: Grid) {
  do_part1(grid, Virus(Point(0, 0), direction.Up), 0, 0)
  |> int.to_string
}

fn do_part1(grid: Grid, virus: Virus, i: Int, result: Int) {
  case i < 10_000 {
    True -> {
      let #(new_virus, new_grid, is_infected) = virus_move_part1(virus, grid)
      do_part1(new_grid, new_virus, i + 1, result + is_infected)
    }
    False -> result
  }
}

fn virus_move_part1(virus: Virus, grid: Grid) {
  case dict.get(grid, virus.node) {
    Ok(Clean) | Error(_) -> {
      let new_direction = direction.turn(virus.direction, direction.Left)
      let new_virus =
        Virus(point.move(virus.node, new_direction), new_direction)
      #(new_virus, dict.insert(grid, virus.node, Infected), 1)
    }
    Ok(Infected) -> {
      let new_direction = direction.turn(virus.direction, direction.Right)
      let new_virus =
        Virus(point.move(virus.node, new_direction), new_direction)
      #(new_virus, dict.insert(grid, virus.node, Clean), 0)
    }
    _ -> panic as "not implemented for part1"
  }
}

fn part2(grid: Grid) {
  do_part2(grid, Virus(Point(0, 0), direction.Up), 0, 0)
  |> int.to_string
}

fn do_part2(grid: Grid, virus: Virus, i: Int, result: Int) {
  case i < 10_000_000 {
    True -> {
      let #(new_virus, new_grid, is_infected) = virus_move_part2(virus, grid)
      do_part2(new_grid, new_virus, i + 1, result + is_infected)
    }
    False -> result
  }
}

fn virus_move_part2(virus: Virus, grid: Grid) {
  case dict.get(grid, virus.node) {
    Ok(Clean) | Error(_) -> {
      let new_direction = direction.turn(virus.direction, direction.Left)
      let new_virus =
        Virus(point.move(virus.node, new_direction), new_direction)
      #(new_virus, dict.insert(grid, virus.node, Weakened), 0)
    }
    Ok(Infected) -> {
      let new_direction = direction.turn(virus.direction, direction.Right)
      let new_virus =
        Virus(point.move(virus.node, new_direction), new_direction)
      #(new_virus, dict.insert(grid, virus.node, Flagged), 0)
    }
    Ok(Flagged) -> {
      let new_direction = direction.opposite(virus.direction)
      let new_virus =
        Virus(point.move(virus.node, new_direction), new_direction)
      #(new_virus, dict.insert(grid, virus.node, Clean), 0)
    }
    Ok(Weakened) -> {
      let new_virus =
        Virus(point.move(virus.node, virus.direction), virus.direction)
      #(new_virus, dict.insert(grid, virus.node, Infected), 1)
    }
  }
}

fn parse(grid: List(String)) {
  do_parse(grid, -12, 12, dict.new())
}

fn do_parse(grid: List(String), x: Int, y: Int, result: Grid) {
  case grid {
    ["\n", ..rest] -> do_parse(rest, -12, y - 1, result)
    [a, ..rest] -> {
      let node = case a {
        "#" -> Infected
        "." -> Clean
        _ -> panic as "node value unknown"
      }
      do_parse(rest, x + 1, y, dict.insert(result, Point(x, y), node))
    }
    _ -> result
  }
}
