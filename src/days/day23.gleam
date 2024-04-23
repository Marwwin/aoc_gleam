import gleam/string
import gleam/io
import gleam/list
import gleam/result
import gleam/int
import gleam/dict.{type Dict}

pub type Program {
  Program(
    instructions: List(Instructions),
    memory: Memory,
    instruction_counter: Int,
  )
}

pub type Instructions {
  Set(Register, Value)
  Sub(Register, Value)
  Mul(Register, Value)
  Jump(Value, Value)
}

pub type Value {
  ANumber(Int)
  ARegister(Register)
}

pub type Register {
  Register(String)
}

pub type Memory =
  Dict(Register, Int)

pub fn solution(input: String) {
  let data =
    input
    |> string.trim
    |> string.split("\n")
    |> parse
  #("Day 23", part1(data), part2())
}

fn part1(instructions: List(Instructions)) {
  let memory =
    ["a", "b", "c", "d", "e", "f", "g", "h"]
    |> list.map(fn(e) { #(Register(e), 0) })
    |> dict.from_list
  do_part1(Program(instructions, memory, 0), 0)
  |> int.to_string
}

fn do_part1(program: Program, result) {
//     io.println("")
//     io.debug(program.instruction_counter)
//   io.debug(program.memory)
  case instruction(program) {
    Ok(Set(a, b)) ->
      do_part1(
        set(program, a, b)
          |> step,
        result,
      )
    Ok(Sub(a, b)) ->
      do_part1(
        sub(program, a, b)
          |> step,
        result,
      )
    Ok(Mul(a, b)) ->
      do_part1(
        mul(program, a, b)
          |> step,
        result + 1,
      )
    Ok(Jump(a, b)) -> do_part1(jump(program, a, b), result)
    Error(_) -> result
  }
}

fn part2() {
  ""
}

fn set(p: Program, reg: Register, value: Value) {
  Program(..p, memory: dict.insert(p.memory, reg, unwrap(p, value)))
}

fn mul(p: Program, reg: Register, value: Value) {
  Program(
    ..p,
    memory: dict.insert(p.memory, reg, unwrap(p, value) * at(p, reg)),
  )
}

fn sub(p: Program, reg: Register, value: Value) {
  Program(
    ..p,
    memory: dict.insert(p.memory, reg, unwrap(p, value) - at(p, reg)),
  )
}

fn jump(p: Program, x: Value, value: Value) {
  case unwrap(p, x) {
    0 -> Program(..p, instruction_counter: p.instruction_counter + 1)
    _ ->
      Program(
        ..p,
        instruction_counter: p.instruction_counter
        + unwrap(p, value),
      )
  }
}

fn at(p: Program, register: Register) {
  case dict.get(p.memory, register) {
    Ok(value) -> value
    Error(_) -> panic as "register not found in memory"
  }
}

fn unwrap(p: Program, v: Value) {
  case v {
    ANumber(n) -> n
    ARegister(r) ->
      case dict.get(p.memory, r) {
        Ok(value) -> value
        Error(_) -> panic as "register not found in memory"
      }
  }
}

fn instruction(p: Program) {
  let instruction = list.at(p.instructions, p.instruction_counter)
  instruction
}

fn step(p: Program) {
  Program(..p, instruction_counter: p.instruction_counter + 1)
}

fn parse(instructions: List(String)) -> List(Instructions) {
  instructions
  |> list.map(do_parse)
}

fn do_parse(instruction: String) -> Instructions {
  case string.split(instruction, " ") {
    ["set", a, b] -> Set(Register(a), to_value(b))
    ["mul", a, b] -> Mul(Register(a), to_value(b))
    ["sub", a, b] -> Sub(Register(a), to_value(b))
    ["jnz", a, b] -> Jump(to_value(a), to_value(b))
    _ -> panic as "unknown input"
  }
}

fn to_value(str) {
  case int.parse(str) {
    Ok(n) -> ANumber(n)
    Error(_) -> ARegister(Register(str))
  }
}
