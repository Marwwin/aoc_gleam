import gleam/list

pub fn sum(list: List(Int)) {
  list.fold(list, 0, fn(acc, n) { acc + n })
}
