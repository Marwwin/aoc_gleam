import gleam/queue
import gleam/int
import program.{
  type Instructions, type Program, type Register, ANumber, Program, Recover,
  Register, Send,
}

pub fn solution(input: String) {
  let instructions = program.parse(input)
  #("Day 18", part1(instructions), part2(instructions))
}

fn part1(instructions: List(Instructions)) {
  do_part1(program.new(instructions))
  |> int.to_string
}

fn do_part1(prog) {
  case program.current_instruction(prog) {
    Recover(_) -> {
      case queue.pop_back(prog.queue) {
        Ok(#(a, _)) -> a
        Error(_) -> panic as "Nothign to recover"
      }
    }
    _ -> {
      do_part1(program.walk(prog))
    }
  }
}

fn part2(instructions: List(Instructions)) {
  let prog_a =
    program.new(instructions)
    |> program.set(Register("p"), ANumber(0))
  let prog_b =
    program.new(instructions)
    |> program.set(Register("p"), ANumber(1))
  do_part2(prog_a, prog_b, 0)
  |> int.to_string
}

fn do_part2(prog_a: Program, prog_b: Program, i) {
  let new_i = case program.current_instruction(prog_b) {
    Send(_) -> i + 1
    _ -> i
  }
  case
    program.current_instruction(prog_a),
    queue.is_empty(prog_a.queue),
    program.current_instruction(prog_b),
    queue.is_empty(prog_b.queue)
  {
    Recover(_), True, Recover(_), True -> i
    Recover(r), _, _, False -> {
      let assert Ok(#(value, new_q)) = queue.pop_front(prog_b.queue)
      do_part2(
        program.walk(
          program.set(prog_a, r, ANumber(value))
          |> program.step,
        ),
        program.walk(Program(..prog_b, queue: new_q)),
        new_i,
      )
    }
    _, False, Recover(r), _ -> {
      let assert Ok(#(value, new_q)) = queue.pop_front(prog_a.queue)
      do_part2(
        program.walk(Program(..prog_a, queue: new_q)),
        program.walk(
          program.set(prog_b, r, ANumber(value))
          |> program.step,
        ),
        new_i,
      )
    }
    _, _, _, _ -> {
      do_part2(program.walk(prog_a), program.walk(prog_b), new_i)
    }
  }
}
