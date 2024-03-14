import gleam/int
import utils
import direction.{type Direction, Down, Left, Right, Up}

pub type Point {
  Point(x: Int, y: Int)
}

pub fn add(a: Point, b: Point) -> Point {
  Point(a.x + b.x, a.y + b.y)
}

pub fn move(p: Point, dir: Direction) -> Point {
  case dir {
    Left -> Point(p.x - 1, p.y)
    Right -> Point(p.x + 1, p.y)
    Up -> Point(p.x, p.y + 1)
    Down -> Point(p.x, p.y - 1)
  }
}

pub fn manhattan(a: Point, b: Point) {
  int.absolute_value(b.x - a.x) + int.absolute_value(b.y - a.y)
}
