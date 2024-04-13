import gleam/list
import gleam/io
import gleam/result
import gleam/int
import gleam/string
import gleam/dict.{type Dict}

pub type DanceMoves {
  Spin(n: Int)
  Exchange(a: Int, b: Int)
  Partner(a: String, b: String)
}

pub fn solution(input) {
  let input =
    input
    |> string.trim()
    |> string.split(",")
    |> parse

  #("Day 16", part1(input), part2(input))
}

fn part1(moves) {
  do_dance(moves, [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p",
  ])
  |> string.join("")
}

fn part2(moves) {
  let state = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p",
  ]
  do_part2(moves, 0, state, memo: dict.new())
  |> string.join("")
}

// This is not optimal since it needs to loop 1_000_000_000 times. 
// Would be a lot faster to just calculate when it starts looping and how long one loop is 
// And then figuring out the correct final state using some modulo math.
// But using memoization works and finishes in around 2min on my machine
// So good enough
fn do_part2(
  moves: List(DanceMoves),
  i: Int,
  state: List(String),
  memo memo: Dict(List(String), List(String)),
) {
  case i {
    i if i < 1_000_000_000 ->
      case dict.get(memo, state) {
        Ok(s) -> do_part2(moves, i + 1, s, memo)
        Error(_) -> {
          let new_state = do_dance(moves, state)
          do_part2(
            moves,
            i + 1,
            new_state,
            memo: dict.insert(memo, state, new_state),
          )
        }
      }
    _ -> state
  }
}

fn do_dance(moves, programs) {
  case moves {
    [Spin(n), ..rest] -> do_dance(rest, spin(programs, n))
    [Exchange(a, b), ..rest] -> do_dance(rest, exchange(programs, a, b))
    [Partner(a, b), ..rest] -> do_dance(rest, partner(programs, a, b))
    [] -> programs
  }
}

fn spin(programs, n) {
  let #(a, b) = list.split(programs, list.length(programs) - n)
  list.append(b, a)
}

fn partner(programs, a, b) {
  programs
  |> list.map(fn(c) {
    case c {
      p if p == a -> b
      p if p == b -> a
      p -> p
    }
  })
}

fn exchange(programs, index_a, index_b) {
  let assert Ok(a) = list.at(programs, index_a)
  let assert Ok(b) = list.at(programs, index_b)

  programs
  |> list.index_map(fn(programs, i) {
    case programs, i {
      _, i if i == index_a -> b
      _, i if i == index_b -> a
      program, _ -> program
    }
  })
}

fn parse(list: List(String)) {
  list.reverse(do_parse(list, []))
}

fn do_parse(list, res) -> List(DanceMoves) {
  case list {
    [] -> res
    [move, ..rest] -> {
      case string.first(move) {
        Ok("s") -> {
          let assert Ok(n) =
            string.drop_left(move, 1)
            |> int.parse
          do_parse(rest, [Spin(n), ..res])
        }
        Ok("x") -> {
          let assert [a, b] =
            string.drop_left(move, 1)
            |> string.split("/")
            |> list.map(fn(e) {
              int.parse(e)
              |> result.unwrap(0)
            })
          do_parse(rest, [Exchange(a, b), ..res])
        }

        Ok("p") -> {
          let assert [a, b] =
            string.drop_left(move, 1)
            |> string.split("/")
          do_parse(rest, [Partner(a, b), ..res])
        }
        _ -> panic("no")
      }
    }
  }
}
