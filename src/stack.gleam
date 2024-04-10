import gleam/list

pub type Stack(t) {
  Stack(stack: List(t))
}

pub fn push(s: Stack(t), value: t) {
  Stack([value, ..s.stack])
}

pub fn pop(s: Stack(t)) {
  case s.stack {
    [] -> Error(Nil)
    [a, ..rest] -> Ok(#(a, Stack(rest)))
  }
}

pub fn size(s: Stack(t)) {
  list.length(s.stack)
}
