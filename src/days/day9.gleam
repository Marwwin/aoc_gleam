import gleam/string
import gleam/int
import gleam/list

type Flavour {
  Group
  Garbage
}

type Char {
  Start(Flavour)
  End(Flavour)
  Nothing
  Random(String)
}

pub fn part1(input: String) {
  let chars =
    input
    |> string.split("")
    |> list.map(parse_char)

  solve(chars).0
  |> int.to_string
}

pub fn part2(input: String) {
  let chars =
    input
    |> string.split("")
    |> list.map(parse_char)

  solve(chars).1
  |> int.to_string
}

fn solve(chars: List(Char)) {
  walk(chars, list.new(), 0, 0)
}

fn walk(chars: List(Char), stack: List(Char), groups: Int, garbage: Int) {
  case stack, chars {
    _, [] -> #(groups, garbage)
    [Nothing, ..rest_stack], [_, ..rest_chars] ->
      walk(rest_chars, rest_stack, groups, garbage)
    _, [Nothing, ..rest_chars] ->
      walk(rest_chars, [Nothing, ..stack], groups, garbage)
    [Start(Garbage), ..rest_stack], [End(Garbage), ..rest_chars] ->
      walk(rest_chars, rest_stack, groups, garbage)
    [Start(Garbage), ..], [_, ..rest_chars] ->
      walk(rest_chars, stack, groups, garbage + 1)
    [Start(Group), ..rest_stack], [End(Group), ..rest_chars] ->
      walk(rest_chars, rest_stack, groups + depth(stack), garbage)
    _, [Start(f), ..rest_chars] ->
      walk(rest_chars, [Start(f), ..stack], groups, garbage)
    _, [_, ..rest_chars] -> walk(rest_chars, stack, groups, garbage)
  }
}

fn depth(stack: List(Char)) {
  list.fold(stack, 0, fn(acc, c) {
    case c {
      Start(Group) -> acc + 1
      _ -> acc
    }
  })
}

fn parse_char(char: String) -> Char {
  case char {
    "<" -> Start(Garbage)
    ">" -> End(Garbage)
    "!" -> Nothing
    "{" -> Start(Group)
    "}" -> End(Group)
    c -> Random(c)
  }
}
