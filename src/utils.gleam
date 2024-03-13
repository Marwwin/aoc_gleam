import gleam/list
import gleam/int

pub type Point {
  Point(x: Int, y: Int)
}

pub fn sum(list: List(Int)) {
  list.fold(list, 0, fn(acc, n) { acc + n })
}

pub fn manhattan(a: Point, b: Point) {
  int.absolute_value(b.x - a.x) - int.absolute_value(b.y - a.y)
}
