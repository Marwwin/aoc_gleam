import gleam/string
import gleam/int
import gleam/list
import gleam/io
import gleam/result

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

  walk(chars, list.new(), 0)
  |> int.to_string
}

pub fn part2(input: String) {
  todo
}

fn walk(chars: List(Char), stack: List(Char), result: Int) {
  case stack, chars {
    _, [] -> result
    [Nothing, ..rest_s], [_, ..rest_c] -> walk(rest_c, rest_s, result)
    [], [Start(c), ..rest_c] -> walk(rest_c, [Start(c)], result)
    s, [Nothing, ..rest_c] -> walk(rest_c, [Nothing, ..s], result)
    [Start(Garbage), ..rest_s], [End(Garbage), ..rest_c] ->
      walk(rest_c, rest_s, result)
    [Start(Garbage), ..], [_, ..rest_c] -> walk(rest_c, stack, result)
    [Start(Group), ..rest_s], [End(Group), ..rest_c] ->
      walk(rest_c, rest_s, result + get_level(stack))
    [Start(_), ..], [End(_), ..rest_c] -> walk(rest_c, stack, result)
    s, [Start(f), ..rest_c] -> walk(rest_c, [Start(f), ..s], result)
    s, [Random(_), ..rest_c] -> walk(rest_c, s, result)
    s, [_, ..rest_c] -> walk(rest_c, s, result)
    s, c -> {
      io.debug(list.first(c))
      io.debug(s)
      panic as "Unknown Char"
    }
  }
}

fn get_level(stack: List(Char)) {
  let score =
    list.fold(stack, 0, fn(acc, c) {
      case c {
        Start(Group) -> acc + 1
        _ -> acc
      }
    })
  score
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
