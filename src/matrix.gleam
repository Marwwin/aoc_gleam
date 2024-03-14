import gleam/dict
import gleam/list
import gleam/io
import point.{type Point, Point}

pub type Matrix =
  dict.Dict(Point, Int)

pub fn new() -> Matrix {
  dict.new()
}

pub fn insert(m: Matrix, p: Point, v: Int) -> Matrix {
  dict.insert(m, p, v)
}

pub fn get(m: Matrix, p: Point) -> Result(Int, Nil) {
  dict.get(m, p)
}

pub fn size(m: Matrix) -> Int {
  dict.size(m)
}

pub fn neighbours(m: Matrix, p: Point) -> List(Int) {
  let offsets = [
    Point(-1, 1),
    Point(0, 1),
    Point(1, 1),
    Point(-1, 0),
    Point(1, 0),
    Point(-1, -1),
    Point(0, -1),
    Point(1, -1),
  ]
  list.flat_map(offsets, fn(offset) {
    case dict.get(m, point.add(p, offset)) {
      Ok(n) -> [n]
      Error(_) -> []
    }
  })
}
