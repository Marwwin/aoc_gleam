import gleam/string
import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/int
import gleam/result

type Register =
  String

type Registers =
  Dict(Register, Int)

pub type Value {
  Number(Int)
  Register(Register)
}

pub type DuetInstructions {
  Sound(Value)
  Set(Register, Value)
  Add(String, Value)
  Multiply(String, Value)
  Modulo(String, Value)
  Recover(Value)
  Jump(Value, Value)
  Empty
}

pub fn solution(input: String) {
  let data = parse(input)
  io.debug(data)
  #("Day 18", "", "")
}

fn part1(instructions: List(DuetInstructions)) {
  let registers = dict.new()
  do_part1(instrctions, registers)
}

fn do_part1(instructions, registers: Registers, freq: List(Int)) {
  case instructions {
    [Sound(v), ..rest] ->
      do_part1(rest, registers, [sound(v, registers), ..freq])
    [Set(a, b), ..rest] -> do_part1(rest, set(a, b, registers), freq)
    [Add(a, b), ..rest] -> do_part1(rest, add(a, b, registers), freq)
  }
}

fn sound(n, registers: Registers) {
  case n {
    Number(n) -> io.debug(n)
    Register(r) ->
      case dict.get(registers, r) {
        Ok(v) -> v
        _ -> panic("no")
      }
    _ -> panic("")
  }
}

fn set(a, b, registers) -> Registers {
  case b {
    Number(n) -> dict.insert(registers, a, n)
    Register(r) ->
      case dict.get(registers, r) {
        Ok(n) -> dict.insert(registers, a, n)
        _ -> panic("shouldnot")
      }
  }
}

fn add(a, b, registers) -> Registers {
      case dict.get(registers, a) {
                    Ok(orig) -> case b {
                    Number(n)
                    }

                    }}

fn parse(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(instruction: String) {
    case string.split(instruction, " ") {
      ["snd", x] -> Sound(parse_value(x))
      ["set", x, y] -> Set(x, parse_value(y))
      ["add", x, y] -> Add(x, parse_value(y))
      ["mul", x, y] -> Multiply(x, parse_value(y))
      ["mod", x, y] -> Modulo(x, parse_value(y))
      ["jgz", x, y] -> Jump(parse_value(x), parse_value(y))
      ["rcv", x] -> Recover(parse_value(x))
      _ -> Empty
    }
  })
}

fn parse_value(str) -> Value {
  case int.parse(str) {
    Ok(n) -> Number(n)
    Error(_) -> Register(str)
  }
}
