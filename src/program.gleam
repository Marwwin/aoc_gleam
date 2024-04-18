import gleam/dict.{type Dict}
import gleam/list
import gleam/io
import gleam/result
import gleam/option.{type Option, None, Some}

pub type Program {
  Program(memory: Memory, i: Int, out: List(Int))
}

pub type Instructions {
  Send(Register)
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

pub fn new() -> Program {
  Program(dict.new(), 0, list.new())
}

pub fn current_instruction(program: Program, instructions) -> Instructions {
  list.at(instructions, program.i)
  |> result.unwrap(Empty)
}

pub fn send(p: Program, x: Register) -> Program {
    io.debug(x)
    io.debug(p)

  Program(..p, out: [register_at(p, x), ..p.out])
  |> step
}

pub fn multiply(p: Program, x: Register, y: Value) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) * unwrap(p, y)),
  )
  |> step
}

pub fn add(p: Program, x, y) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) + unwrap(p, y)),
  )
  |> step
}

pub fn modulo(p: Program, x, y) -> Program {
  Program(
    ..p,
    memory: dict.insert(p.memory, x, register_at(p, x) % unwrap(p, y)),
  )
  |> step
}

pub fn jump(program, x: Value, y: Value) -> Program {
  let i = case unwrap(program, x) {
    n if n <= 0 -> 1
    _ -> unwrap(program, y)
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
  Program(..p, memory: dict.insert(p.memory, register, unwrap(p, value)))
  |> step
}

pub fn unwrap(program: Program, value: Value) -> Int {
  case value {
    ANumber(n) -> n
    ARegister(r) -> register_at(program, r)
  }
}

pub fn pop_out(program: Program) {
  case program.out {
    [a, ..rest] -> #(Program(..program, out: rest), Some(a))
    [] -> #(program, None)
  }
}

pub fn step(program: Program) {
  Program(..program, i: program.i + 1)
}

pub fn register_at(program: Program, register: Register) -> Int {
  dict.get(program.memory, register)
  |> result.unwrap(0)
}

pub fn get_raw(program: Program, register: Register) -> Result(Int, Nil) {
  dict.get(program.memory, register)
}
