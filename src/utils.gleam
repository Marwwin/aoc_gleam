import gleam/list
import gleam/int

pub type Direction {
  Up
  Left
  Down
  Right
}

pub fn sum(list: List(Int)) {
  list.fold(list, 0, fn(acc, n) { acc + n })
}
