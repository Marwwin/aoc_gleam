import gleam/string
import gleam/dict
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/list
import gleam/int
import program.{
  type Instructions, type Program, type Register, type Value, ANumber, ARegister,
  Add, Empty, Jump, Modulo, Multiply, Program, Recover, Register, Send, Set,
}

pub fn solution(input: String) {
  let data = parse(input)
  part2(data)
  |> io.debug
  #("Day 18", part1(data), "")
}

fn part1(instructions: List(Instructions)) {
  let program = Program(memory: dict.new(), i: 0, out: list.new())
  do_part1(instructions, program)
  |> option.unwrap(0)
  |> int.to_string
}

fn do_part1(instructions, program) {
  case program.current_instruction(program, instructions) {
    Recover(a) -> {
      let bus = program.pop_out(program)
      bus.1
    }
    _ -> {
      do_part1(instructions, walk(instructions, program, None))
    }
  }
}

fn walk(instructions, prog: Program, queue: Option(Int)) {
  case list.at(instructions, prog.i) {
    Ok(Send(v)) -> program.send(prog, v)
    Ok(Set(a, b)) -> program.set(prog, a, b)
    Ok(Add(a, b)) -> program.add(prog, a, b)
    Ok(Multiply(a, b)) -> program.multiply(prog, a, b)
    Ok(Modulo(a, b)) -> program.modulo(prog, a, b)
    Ok(Jump(a, b)) -> program.jump(prog, a, b)
    Ok(Recover(v)) -> program.recover(prog, v, queue)
    Ok(Empty) -> panic as "is no"
    Error(_) -> panic as "you done goofed up"
        
  }
}

fn part2(instructions: List(Instructions)) {
  let prog_a =
    program.new()
    |> program.set(Register("p"), ANumber(0))
  let prog_b =
    program.new()
    |> program.set(Register("p"), ANumber(1))
  do_part2(instructions, prog_a, prog_b, 0)
}

fn do_part2(instructions, prog_a: Program, prog_b: Program, i) {
  io.println("")
  io.debug(i)
  io.debug(prog_a)

  io.debug(program.current_instruction(prog_a, instructions))

  io.debug(prog_b)
  io.debug(program.current_instruction(prog_b, instructions))
  io.println("")
  case i {
    i if i > 100000 -> prog_a
    _ ->
      case
        program.current_instruction(prog_a, instructions),
        program.current_instruction(prog_b, instructions)
      {
        Recover(_), Recover(_) -> prog_a
        Recover(_), _ -> {
          let bus = program.pop_out(prog_b)
          do_part2(
            instructions,
            walk(instructions, prog_a, bus.1),
            walk(instructions, bus.0, None),
            i + 1,
          )
        }
        _, Recover(_) -> {
          let bus = program.pop_out(prog_a)
          do_part2(
            instructions,
            walk(instructions, bus.0, None),
            walk(instructions, prog_b, bus.1),
            i + 1,
          )
        }

        _, _ ->
          do_part2(
            instructions,
            walk(instructions, prog_a, None),
            walk(instructions, prog_b, None),
            i + 1,
          )
      }
  }
}

fn parse(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(instruction: String) {
    case string.split(instruction, " ") {
      ["snd", x] -> Send(Register(x))
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
