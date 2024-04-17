import gleam/string
import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/int
import gleam/result

type Program {
  Program(reg: Registers, i: Int, in_bus: List(Int))
}

type Register {
  Register(String)
}

type Registers =
  Dict(Value, Int)

pub type Value {
  ANumber(Int)
  ARegister(String)
}

pub type Instructions {
  Sound(Value)
  Set(Value, Value)
  Add(Value, Value)
  Multiply(Value, Value)
  Modulo(Value, Value)
  Recover(Value)
  Jump(Value, Value)
  Empty
}

pub fn solution(input: String) {
  let data = parse(input)
  io.debug(data)
  part1(data)
  |> io.debug
  #("Day 18", part1(data), "")
}

fn part1(instructions: List(Instructions)) {
  let regs = dict.new()
  let program = Program(reg: dict.new(), i: 0, in_bus: list.new())
  do_part1(instructions, program)
}

fn do_part1(instructions, program) {
  todo
}

fn walk(instructions, prog: Program) {
  case list.at(instructions, prog.i) {
    Ok(Sound(value)) -> {
      let bus = [sound(value, prog.reg), ..prog.in_bus]
      do_part1(instructions, Program(..prog, i: { prog.i + 1 }, in_bus: bus))
    }
    Ok(Set(a, b)) ->
      do_part1(
        instructions,
        Program(..prog, reg: set(a, b, prog.reg), i: { prog.i + 1 }),
      )
    Ok(Add(a, b)) ->
      do_part1(
        instructions,
        Program(..prog, reg: add(a, b, prog.reg), i: { prog.i + 1 }),
      )
    Ok(Multiply(a, b)) ->
      do_part1(
        instructions,
        Program(..prog, reg: multiply(a, b, prog.reg), i: { prog.i + 1 }),
      )
    Ok(Modulo(a, b)) ->
      do_part1(
        instructions,
        Program(..prog, reg: modulo(a, b, prog.reg), i: { prog.i + 1 }),
      )
    Ok(Jump(a, b)) ->
      do_part1(instructions, Program(..prog, i: prog.i + jump(a, b, prog.reg)))
    Ok(Recover(v)) -> {
      case unwrap(v, prog.reg), prog.in_bus {
        0, _ -> do_part1(instructions, Program(..prog, i: prog.i + 1))
        _, [a, ..] -> a
        _, _ -> panic as "hould not"
      }
    }
    Ok(Empty) -> panic as "is no"
    Error(_) -> panic as "you done goofed up"
  }
}

fn part2(instructions: List(Instructions)) {
  let reg_a =
    dict.new()
    |> dict.insert(ARegister("p"), 0)
  let reg_b =
    dict.new()
    |> dict.insert(ARegister("p"), 1)
  do_part2(instructions, 0, reg_a, list.new(), 0, reg_b, list.new())
}

fn do_part2(instructions, a_i, reg_a, a_event, b_i, reg_b, b_event) {
  todo
}

fn sound(x: Value, regs: Registers) {
  unwrap(x, regs)
}

fn multiply(x: Value, y, regs: Registers) {
  dict.insert(regs, x, unwrap(x, regs) * unwrap(y, regs))
}

fn add(x: Value, y, regs: Registers) {
  dict.insert(regs, x, unwrap(x, regs) + unwrap(y, regs))
}

fn modulo(x: Value, y, regs: Registers) {
  dict.insert(regs, x, unwrap(x, regs) % unwrap(y, regs))
}

fn jump(x: Value, y: Value, regs) {
  case unwrap(x, regs) {
    n if n <= 0 -> 1
    _ -> unwrap(y, regs)
  }
}

fn unwrap(value: Value, regs: Registers) {
  case value {
    ANumber(n) -> n
    r -> get(r, regs)
  }
}

fn set(reg: Value, value: Value, regs: Registers) {
  dict.insert(regs, reg, unwrap(value, regs))
}

fn get(reg: Value, regs: Registers) {
  dict.get(regs, reg)
  |> result.unwrap(0)
}

fn parse(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(instruction: String) {
    case string.split(instruction, " ") {
      ["snd", x] -> Sound(parse_value(x))
      ["set", x, y] -> Set(parse_value(x), parse_value(y))
      ["add", x, y] -> Add(parse_value(x), parse_value(y))
      ["mul", x, y] -> Multiply(parse_value(x), parse_value(y))
      ["mod", x, y] -> Modulo(parse_value(x), parse_value(y))
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
