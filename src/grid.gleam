import gleam/io
import gleam/int
import point.{type Point, Point}
import gleam/list
import gleam/dict.{type Dict}

pub type Grid {
  Grid(grid: Dict(Point, String), row_size: Int)
}

pub fn at(grid: Grid, point: Point) -> Result(String, Nil) {
  dict.get(grid.grid, point)
}

pub fn from_list(input: List(String), row_size) {
  input
  |> list.index_fold(dict.new(), fn(acc, value, i) {
    dict.insert(acc, Point(x: i % row_size, y: i / row_size), value)
  })
  |> Grid(row_size)
}

pub fn index_to_point(grid: Grid, i: Int) -> Point {
  Point(i % grid.row_size, i / grid.row_size)
}

pub fn adjacent(grid: Grid, point: Point) -> List(#(Point, String)) {
  [
    Point(point.x + 1, point.y),
    Point(point.x - 1, point.y),
    Point(point.x, point.y + 1),
    Point(point.x, point.y - 1),
  ]
  |> list.flat_map(fn(p) {
    case at(grid, p) {
      Ok(v) -> [#(p, v)]
      Error(e) -> []
    }
  })
}
