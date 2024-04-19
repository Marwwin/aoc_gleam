import gleam/string
import gleam/dict
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/list
import gleam/result
import gleam/queue
import gleam/int
import program.{
  type Instructions, type Program, type Register, type Value, ANumber, ARegister,
  Add, Empty, Jump, Modulo, Multiply, Program, Recover, Register, Send, Set,
}

pub fn solution(input: String) {
  let instructions = program.parse(input)
  #("Day 18", part1(instructions), part2(instructions))
}

fn part1(instructions: List(Instructions)) {
  let program = program.new()
  do_part1(instructions, program)
  |> int.to_string
}

fn do_part1(instructions, p) {
  case program.current_instruction(p, instructions) {
    Recover(_) -> {
      case queue.pop_back(p.queue) {
        Ok(#(a, _)) -> a
        Error(_) -> panic as "Nothign to recover"
      }
    }
    _ -> {
      do_part1(instructions, program.walk(instructions, p))
    }
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
  |> int.to_string
}

fn do_part2(instructions, prog_a: Program, prog_b: Program, i) {
  let new_i = case program.current_instruction(prog_b, instructions) {
    Send(_) -> i + 1
    _ -> i
  }
  case
    program.current_instruction(prog_a, instructions),
    queue.is_empty(prog_a.queue),
    program.current_instruction(prog_b, instructions),
    queue.is_empty(prog_b.queue)
  {
    Recover(_), True, Recover(_), True -> i
    Recover(r), _, _, False -> {
      let assert Ok(#(value, new_q)) = queue.pop_front(prog_b.queue)
      do_part2(
        instructions,
        program.walk(
          instructions,
          program.set(prog_a, r, ANumber(value))
            |> program.step,
        ),
        program.walk(instructions, Program(..prog_b, queue: new_q)),
        new_i,
      )
    }
    _, False, Recover(r), _ -> {
      let assert Ok(#(value, new_q)) = queue.pop_front(prog_a.queue)
      do_part2(
        instructions,
        program.walk(instructions, Program(..prog_a, queue: new_q)),
        program.walk(
          instructions,
          program.set(prog_b, r, ANumber(value))
            |> program.step,
        ),
        new_i,
      )
    }
    _, _, _, _ -> {
      do_part2(
        instructions,
        program.walk(instructions, prog_a),
        program.walk(instructions, prog_b),
        new_i,
      )
    }
  }
}
