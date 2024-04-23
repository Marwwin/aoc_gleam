import gleam/string
import gleam/dict.{type Dict}
import gleam/result
import gleam/int
import gleam/list
import gleam/io
import direction.{type Direction, Left, Right}

pub type TuringMachine {
  TuringMachine(
    diagnostics: Int,
    counter: Int,
    instructions: Instructions,
    state: String,
    tape: Tape,
    cursor: Int,
  )
}

pub type Tape =
  Dict(Int, Int)

pub type Diagnostics {
  Diagnostics(Int)
}

pub type Rule {
  Rule(write: Int, move: Direction, continue: String)
}

pub type Instruction {
  Instruction(state: String, zero: Rule, one: Rule)
}

pub type Instructions =
  Dict(String, Instruction)

pub fn solution(input: String) {
  let assert [begin, diagnostic, _, ..rest] =
    input
    |> string.split("\n")
  let data =
    rest
    |> list.sized_chunk(10)
    |> list.map(fn(l) {
      list.map(l, fn(s) {
        s
        |> string.trim
        |> string.drop_right(1)
      })
    })

  let instructions = parse(data)

  let machine =
    TuringMachine(
      parse_diagnostic(diagnostic),
      0,
      instructions,
      "A",
      dict.new(),
      0,
    )
  #("Day 25", part1(machine), part2())
}

fn part1(machine) -> String {
  case machine.diagnostics > machine.counter {
    True -> next(machine)
    False ->
      tape_state(machine)
      |> int.to_string
  }
}

fn tape_state(m: TuringMachine) {
  list.fold(dict.to_list(m.tape), 0, fn(acc, e) { acc + e.1 })
}

fn next(m: TuringMachine) {
  case dict.get(m.instructions, m.state) {
    Ok(Instruction(state, zero, one)) ->
      case dict.get(m.tape, m.cursor) {
        Ok(1) -> part1(do(m, one))
        Ok(0) | Error(_) -> part1(do(m, zero))
        _ -> panic as "wonky tape reading"
      }
    _ -> panic as "unknown state given"
  }
}

fn do(m, rule) {
  let Rule(write, move, continue) = rule
  let dir = case move {
    Left -> -1
    Right -> 1
    _ -> panic as "unknown direction"
  }
  TuringMachine(
    ..m,
    counter: m.counter
    + 1,
    tape: dict.insert(m.tape, m.cursor, write),
    cursor: m.cursor
    + dir,
    state: continue,
  )
}

fn part2() {
  ""
}

fn parse(strs: List(List(String))) {
  do_parse(strs, dict.new())
}

fn do_parse(strs: List(List(String)), result) {
  case strs {
    [
      [
        "In state " <> id,
        "If the current value is 0",
        "- Write the value " <> zero_write,
        "- Move one slot to the " <> zero_direction,
        "- Continue with state " <> zero_to_state,
        "If the current value is 1",
        "- Write the value " <> one_write,
        "- Move one slot to the " <> one_direction,
        "- Continue with state " <> one_to_state,
        _,
      ],
      ..rest
    ] ->
      do_parse(
        rest,
        dict.insert(
          result,
          id,
          Instruction(
            id,
            to_rule(zero_write, zero_direction, zero_to_state),
            to_rule(one_write, one_direction, one_to_state),
          ),
        ),
      )
    [] -> result
    _ -> panic as "can not parse Rule"
  }
}

fn parse_diagnostic(diag) {
  case diag {
    "Perform a diagnostic checksum after " <> d ->
      string.drop_right(d, 7)
      |> int.parse
      |> result.unwrap(0)
    _ -> panic as "unknown diagnostics str"
  }
}

fn to_rule(write, dir, state) {
  let assert Ok(w) = int.parse(write)
  Rule(w, direction.from_string(dir), state)
}
