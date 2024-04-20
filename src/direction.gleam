pub type Direction {
  Up
  Left
  Down
  Right
}

pub fn opposite(d: Direction) {
  case d {
    Up -> Down
    Down -> Up
    Left -> Right
    Right -> Left
  }
}
