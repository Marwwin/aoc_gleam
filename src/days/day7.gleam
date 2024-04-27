import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string

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
  //#("Day 7", root, part2(db, root))
}

fn part2(db, root) -> String {
  tree_walk(db, [root], list.new())
  ""
}

fn tree_walk(db, stack: List(String), weights: List(String)) {
  case stack {
    [head, ..tail] -> {
      let children = case dict.get(db, head) {
        Ok(Program(_, _, chs)) -> {
          let childrens =
            chs
            |> list.map(fn(c) {
              let assert Ok(p) = dict.get(db, c)
              p
            })
          let off_balance =
            childrens
            |> list.fold(safe_get_head_weight(childrens), fn(acc, e) {
              let assert Program(_, w, _) = e
              int.bitwise_exclusive_or(acc, w)
            })
          let next =
            childrens
            |> list.filter(fn(c) {
              let assert Program(_, w, _) = c
              w == off_balance
            })
            |> list.map(fn(c) {
              let assert Program(id, _, _) = c
              id
            })
          io.debug(childrens)
          io.debug(off_balance)
          io.debug(next)
          tree_walk(db, next, weights)
        }
        _ -> []
      }
      io.debug(head)
      io.debug(children)
      tree_walk(db, children, weights)
    }
    [] -> weights
  }
}

fn safe_head(list) {
  case list {
    [head, ..] -> head
    [] -> []
  }
}

fn safe_get_head_weight(list) {
  case list {
    [Program(_, w, _), ..] -> w
    _ -> 0
  }
}

fn walk(db: Dict(String, Program), stack, weights: Dict(String, Int)) {
  case stack {
    [] -> []
    [node, ..rest] -> {
      case dict.get(db, node) {
        Ok(Program(name, weight, children)) -> {
          let children_weight = count_children(db, children, dict.new())
          let sum = count_children(db, children, dict.new())
          let res = print_weights(db, children, [])
          io.println("")
          io.println(
            name
            <> " "
            <> int.to_string(weight)
            <> " Has Children "
            <> string.join(children, ","),
          )
          io.debug(res)
          let n_stack = list.append(children, rest)
          walk(db, n_stack, weights)
        }
        Ok(Empty) -> []
        Error(_) -> []
      }
    }
  }
}

fn count_children(db, children, weights) {
  case children {
    [] -> []
    [cg, ..rest] ->
      case dict.get(weights, cg) {
        Ok(w) -> w
        Error(_) -> panic("Buu")
      }
  }
}

fn print_weights(db, children, res) {
  case children {
    [] -> res
    [c, ..rest] -> {
      let assert Ok(Program(name, weight, _)) = dict.get(db, c)
      //io.println(" " <> name <> " " <> int.to_string(weight))
      print_weights(db, rest, [#(name, weight), ..res])
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
