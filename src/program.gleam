import gleam/dict.{type Dict}
import gleam/list
import gleam/io
import gleam/int
import gleam/string
import gleam/result
import gleam/option.{type Option, None, Some}
import gleam/queue.{type Queue}

pub type Program {
  Program(
    memory: Memory,
    i: Int,
    queue: Queue(Int),
    instructions: List(Instructions),
  )
}

pub type Instructions {
  Send(Value)
  Set(Register, Value)
  Add(Register, Value)
  Multiply(Register, Value)
  Modulo(Register, Value)
  Recover(Register)
  Jump(Value, Value)
  Empty
}

pub type Memory =
  Dict(Register, Int)

pub type Register {
  Register(String)
}

pub type Value {
  ANumber(Int)
  ARegister(Register)
}

pub fn new(instructions) -> Program {
  Program(dict.new(), 0, queue.new(), instructions)
}

pub fn walk(prog: Program) {
  case current_instruction(prog) {
    Send(v) ->
      send(prog, v)
      |> step
    Set(a, b) ->
      set(prog, a, b)
      |> step
    Add(a, b) ->
      add(prog, a, b)
      |> step
    Multiply(a, b) ->
      multiply(prog, a, b)
      |> step
    Modulo(a, b) ->
      modulo(prog, a, b)
      |> step
    Jump(a, b) -> jump(prog, a, b)
    Recover(_) -> prog
    Empty -> panic as "is no"
  }
}

pub fn current_instruction(program: Program) -> Instructions {
  list.at(program.instructions, program.i)
  |> result.unwrap(Empty)
}

pub fn send(p: Program, x: Value) -> Program {
  Program(..p, queue: queue.push_back(p.queue, unwrap_value(p, x)))
}

pub fn multiply(p: Program, x: Register, y: Value) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) * unwrap_value(p, y)),
  )
}

pub fn add(p: Program, x, y) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) + unwrap_value(p, y)),
  )
}

pub fn modulo(p: Program, x, y) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) % unwrap_value(p, y)),
  )
}

pub fn jump(program, x: Value, y: Value) -> Program {
  let i = case unwrap_value(program, x) {
    n if n <= 0 -> 1
    _ -> unwrap_value(program, y)
  }
  Program(..program, i: program.i + i)
}

pub fn recover(
  program: Program,
  register: Register,
  from: Option(Int),
) -> Program {
  case from {
    None -> program
    Some(v) -> set(program, register, ANumber(v))
  }
}

pub fn set(p: Program, register: Register, value: Value) -> Program {
  Program(..p, memory: dict.insert(p.memory, register, unwrap_value(p, value)))
}

pub fn unwrap_value(program: Program, value: Value) -> Int {
  case value {
    ANumber(n) -> n
    ARegister(r) -> register_at(program, r)
  }
}

pub fn step(program: Program) {
  Program(..program, i: program.i + 1)
}

/// Will try to access register, if not found it will return 0. 
pub fn register_at(program: Program, register: Register) -> Int {
  dict.get(program.memory, register)
  |> result.unwrap(0)
}

pub fn get_raw(program: Program, register: Register) -> Result(Int, Nil) {
  dict.get(program.memory, register)
}

pub fn parse(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(instruction: String) {
    case string.split(instruction, " ") {
      ["snd", x] -> Send(parse_value(x))
      ["set", x, y] -> Set(Register(x), parse_value(y))
      ["add", x, y] -> Add(Register(x), parse_value(y))
      ["mul", x, y] -> Multiply(Register(x), parse_value(y))
      ["mod", x, y] -> Modulo(Register(x), parse_value(y))
      ["jgz", x, y] -> Jump(parse_value(x), parse_value(y))
      ["rcv", x] -> Recover(Register(x))
      _ -> Empty
    }
  })
}

fn parse_value(str) -> Value {
  case int.parse(str) {
    Ok(n) -> ANumber(n)
    Error(_) -> ARegister(Register(str))
  }
}
