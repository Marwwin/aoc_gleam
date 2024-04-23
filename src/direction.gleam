import gleam/string

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

pub fn turn(d: Direction, towards: Direction) {
  case towards {
    Left ->
      case d {
        Up -> Left
        Left -> Down
        Down -> Right
        Right -> Up
      }
    Right ->
      case d {
        Up -> Right
        Right -> Down
        Down -> Left
        Left -> Up
      }
    _ -> panic as "Can only turn Left or Right"
  }
}

pub fn from_string(str) {
  case string.lowercase(str) {
    "left" -> Left
    "right" -> Right
    "up" -> Up
    "down" -> Down
    _ -> panic as "unknown direction"
  }
}
