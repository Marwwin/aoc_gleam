import gleeunit
import gleeunit/should
import gleam/io
import gleam/list
import utils
import point.{Point}
import matrix

pub fn main() {
  gleeunit.main()
}

pub fn create_matrix_test() {
  matrix.new()
  |> matrix.insert(Point(0, 0), 1)
  |> matrix.get(Point(0, 0))
  |> should.equal(Ok(1))

  matrix.new()
  |> matrix.insert(Point(0, 0), 1)
  |> matrix.insert(Point(1, 0), 2)
  |> matrix.insert(Point(0, 1), 3)
  |> matrix.size()
  |> should.equal(3)
}

pub fn get_neighbours_test() {
  let neighbours =
    matrix.new()
    |> matrix.insert(Point(0, 0), 1)
    |> matrix.insert(Point(1, 0), 2)
    |> matrix.insert(Point(0, 1), 3)
    |> matrix.neighbours(Point(0, 0))

  list.length(neighbours)
  |> should.equal(2)

  utils.sum(neighbours)
  |> should.equal(5)
}
