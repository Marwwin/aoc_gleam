//// This is a bit of a mess but it works..

import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

type Program {
  Program(name: String, weight: Int, children: List(String))
  LeafProgram(name: String, weight: Int)
  Empty
}

pub fn solution(input) {
  let db =
    input
    |> parse
    |> create_db

  let keys = set.from_list(dict.keys(db))
  let children = get_set_of_children(db)

  let root =
    set.difference(keys, children)
    |> set.to_list
    |> list.first
    |> result.unwrap("")
  #("Day 7", root, part2(db, root))
}

fn part2(db, root) -> String {
  walk(db, root, list.new())
  ""
}

// Walk down the tree until you find a balanced tower
// The parent holding that tower is unbalanced
// Then walk back one step and calculate the correct weight
fn walk(db, next, seen) {
  let childrens = list.map(children(db, next), fn(e) { get_weight(db, e) })
  case get_unbalanced_node(childrens) {
    Ok(child) -> {
      walk(db, child, [next, ..seen])
    }
    Error(_) -> backtrack(db, [next, ..seen])
  }
}

fn backtrack(db, seen: List(String)) {
  let assert [a, b, ..] = seen
  let unbalanced_nodes_children_weight =
    list.fold(children(db, a), 0, fn(acc, e) { acc + get_weight(db, e).1 })
  let siblings = list.map(children(db, b), fn(e) { get_weight(db, e) })
  let target_weight = sibling_weight(siblings, a)
  target_weight - unbalanced_nodes_children_weight
}

fn sibling_weight(l: List(#(String, Int)), node) {
  case l {
    [a, ..] if a.0 != node -> a.1
    [_, ..rest] -> sibling_weight(rest, node)
    _ -> panic as "oh noe"
  }
}

fn get_unbalanced_node(l: List(#(String, Int))) -> Result(String, Nil) {
  let values =
    list.map(l, fn(e) { e.1 })
    |> list.sort(int.compare)
  let unique = case values {
    [a, b, ..] if a == b ->
      list.last(values)
      |> result.unwrap(0)
    [a, ..] -> a
    _ -> panic as "get_unbalanced_node should not"
  }
  case list.filter(l, fn(e) { e.1 == unique }) {
    [#(name, _)] -> Ok(name)
    _ -> Error(Nil)
  }
}

fn get_weight(db, node) -> #(String, Int) {
  case dict.get(db, node) {
    Ok(LeafProgram(name, weight)) -> #(name, weight)
    Ok(Program(name, weight, children)) -> {
      let w =
        weight
        + list.fold(children, 0, fn(acc, c) { acc + get_weight(db, c).1 })
      #(name, w)
    }
    _ -> panic as "oops"
  }
}

fn children(db, node) {
  case dict.get(db, node) {
    Ok(Program(_, _, children)) -> children
    _ -> []
  }
}

fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.map(row_to_program)
}

fn row_to_program(row: String) {
  case string.split(row, " ") {
    [name, weight] -> LeafProgram(name, parse_weight(weight))
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
      LeafProgram(name, weight) ->
        dict.insert(db, name, LeafProgram(name, weight))
      Empty -> db
    }
  })
}

fn get_set_of_children(programs: Dict(String, Program)) -> Set(String) {
  programs
  |> dict.values
  |> list.fold(set.new(), fn(s, program) {
    case program {
      Program(_, _, children) -> set.union(s, set.from_list(children))
      LeafProgram(_, _) -> s
      Empty -> s
    }
  })
}
