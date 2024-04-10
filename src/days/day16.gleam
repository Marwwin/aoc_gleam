import gleam/list
import gleam/result
import gleam/int
import gleam/string

pub type DanceMoves {
  Spin(n: Int)
  Exchange(a: Int, b: Int)
  Partner(a: String, b: String)
}

pub fn solution(input) {
let input =   input
  |> string.trim()
  |> string.split(",")
  |> parse

  #("Day 16", string.join(part1(input), ""), "")

}
 fn part1(moves){
   do_dance(moves, ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"])
}

fn do_dance(moves, programs){
    case moves{
        [Spin(n), ..rest] -> do_dance(rest, spin(programs,n))
        [Exchange(a,b), ..rest] -> do_dance(rest, exchange(programs,a,b))
        [Partner(a,b), ..rest] -> do_dance(rest, partner(programs,a,b))
        [] -> programs
    }
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

fn exchange(program, index_a, index_b) {
  let assert Ok(a) = list.at(program, index_a)
  let assert Ok(b) = list.at(program, index_b)
  program
  |> list.index_map(fn(c, i) {
    case c, i {
      _, i if i == index_a -> b
      _, i if i == index_b -> a
      c, _ -> c
    }
  })
}
