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
  ANumber(Int)
  ARegister(Register)
}

pub type DuetInstructions {
  Sound(Value)
  Set(Register, Value)
  Add(Register, Value)
  Multiply(Register, Value)
  Modulo(Register, Value)
  Recover(Value)
  Jump(Value, Value)
  Empty
}

pub fn solution(input: String) {
  let data = parse(input)
  io.debug(data)
  part1(data)
  |> io.debug
  #("Day 18", "", "")
}

fn part1(instructions: List(DuetInstructions)) {
  let registers = dict.new()
  do_part1(0, instructions, registers, list.new())
}

fn do_part1(i, instructions, registers: Registers, freq: List(Int)) {
//   io.debug("")
//   io.debug(i)
//   io.debug(registers)
//   io.debug(list.at(instructions, i))
  case list.at(instructions, i) {
    Ok(Sound(value)) ->
      do_part1(i + 1, instructions, registers, [sound(value, registers), ..freq])
    Ok(Set(a, b)) -> do_part1(i + 1, instructions, set(a, b, registers), freq)
    Ok(Add(a, b)) -> do_part1(i + 1, instructions, add(a, b, registers), freq)
    Ok(Multiply(a, b)) ->
      do_part1(i + 1, instructions, multiply(a, b, registers), freq)
    Ok(Modulo(a, b)) ->
      do_part1(i + 1, instructions, modulo(a, b, registers), freq)
    Ok(Jump(a, b)) ->
      do_part1(i + jump(a, b, registers), instructions, registers, freq)
    Ok(Recover(v)) -> {
      case unwrap(v, registers), freq {
        0, _ -> do_part1(i + 1, instructions, registers, freq)
        _, [a, ..] -> a
        _, _ -> panic as "hould not"
      }
    }
    Ok(Empty) -> panic("is no")
    Error(_) -> panic("you done goofed up")
  }
}

fn set(reg: String, value: Value, registers: Registers) {
  dict.insert(registers, reg, unwrap(value, registers))
}

fn unwrap(value: Value, registers: Registers) {
  case value {
    ANumber(n) -> n
    ARegister(r) -> get(registers, r)
  }
}

fn get(registers: Registers, reg: Register) {
  case dict.get(registers, reg) {
    Ok(value) -> value
    Error(_) -> 0
  }
}

fn multiply(x: Register, y, registers: Registers) {
  dict.insert(registers, x, get(registers, x) * unwrap(y, registers))
}

fn add(x: Register, y, registers: Registers) {
  dict.insert(registers, x, get(registers, x) + unwrap(y, registers))
}

fn modulo(x: Register, y, registers: Registers) {
  dict.insert(registers, x, get(registers, x) % unwrap(y, registers))
}

fn jump(x, y, registers) {
  case unwrap(x, registers) {
    n if n <= 0 -> 1
    _ -> unwrap(y, registers)
  }
}

fn sound(x: Value, registers) {
  unwrap(x, registers)
}

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
    Ok(n) -> ANumber(n)
    Error(_) -> ARegister(str)
  }
}
