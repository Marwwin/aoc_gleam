import gleam/list
import gleam/set.{type Set}
import gleam/int
import gleam/result
import gleam/io
import gleam/string
import gleam/dict.{type Dict}

type Program {
  Program(name: String, weight: Int, children: List(String))
  Empty
}

pub fn solution(input) {
  let db =
    input
    |> parse
    |> create_db

  let keys = set.from_list(dict.keys(db))
  let children = get_children(db)

  let root =
    set.difference(keys, children)
    |> set.to_list
    |> list.first
    |> result.unwrap("")
  #("Day 7", root, part2(db, root))
}

fn part2(db, root) -> String {
  walk(db, [root])
  ""
}

fn walk(db: Dict(String, Program), stack) {
  case stack {
    [] -> []
    [node, ..rest] -> {
      case dict.get(db, node) {
        Ok(Program(name, _, children)) -> {
          io.debug(name)
          print_weights(db, children)
          let n_stack = list.append(children, rest)
          walk(db, n_stack)
        }
        Ok(Empty) -> []
        Error(_) -> []
      }
    }
  }
}

fn print_weights(db, children) {
  case children {
    [] -> ""
    [c, ..rest] -> {
      let assert Ok(Program(name, weight, _)) = dict.get(db, c)
      io.println(" " <> name <> " " <> int.to_string(weight))
      print_weights(db, rest)
    }
  }
}

fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.map(row_to_program)
}

fn row_to_program(row: String) {
  case string.split(row, " ") {
    [name, weight] -> Program(name, parse_weight(weight), [])
    [name, weight, "->", ..children] ->
      Program(name, parse_weight(weight), parse_children(children))
    _ -> Empty
  }
}

fn parse_weight(weight: String) {
  weight
  |> string.replace("(", "")
  |> string.replace(")", "")
  |> int.parse
  |> result.unwrap(0)
}

fn parse_children(children: List(String)) {
  children
  |> list.map(fn(child) { string.replace(child, ",", "") })
}

fn create_db(programs: List(Program)) {
  programs
  |> list.fold(dict.new(), fn(db, program) {
    case program {
      Program(name, weight, children) ->
        dict.insert(db, name, Program(name, weight, children))
      Empty -> db
    }
  })
}

fn get_children(programs: Dict(String, Program)) -> Set(String) {
  programs
  |> dict.values
  |> list.fold(set.new(), fn(s, program) {
    case program {
      Program(_, _, children) -> set.union(s, set.from_list(children))
      Empty -> s
    }
  })
}
