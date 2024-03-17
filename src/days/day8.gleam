import gleam/string
import gleam/io
import gleam/int
import gleam/result
import gleam/list
import gleam/dict.{type Dict}

pub fn part1(input: String) {
  let result =
    input
    |> string.split("\n")
    |> list.fold(#(dict.new(), 0), process_instruction)

  dict.values(result.0)
  |> list.fold(0, int.max)
  |> int.to_string
}

pub fn part2(input: String) {
  let result =
    input
    |> string.split("\n")
    |> list.fold(#(dict.new(), 0), process_instruction)
  result.1
  |> int.to_string
}

fn process_instruction(memory: #(Dict(String, Int), Int), inst: String) {
  case string.split(inst, " ") {
    [register, op, amount, "if", cond_a, cond_op, cond_b] -> {
      let a =
        dict.get(memory.0, cond_a)
        |> result.unwrap(0)
      let b =
        int.parse(cond_b)
        |> result.unwrap(0)

      case evaluate(a, cond_op, b) {
        True -> {
          let v =
            dict.get(memory.0, register)
            |> result.unwrap(0)
          let amount_int =
            amount
            |> int.parse
            |> result.unwrap(0)
          let to_add = case op {
            "inc" -> v + amount_int
            "dec" -> v - amount_int
            _ -> 0
          }
          let new_d = dict.insert(memory.0, register, to_add)
          #(new_d, int.max(memory.1, to_add))
        }
        False -> memory
      }
    }
    _ -> memory
  }
}

fn evaluate(a, cond, b) {
  case cond {
    "<" -> a < b
    ">" -> a > b
    ">=" -> a >= b
    "<=" -> a <= b
    "==" -> a == b
    "!=" -> a != b
    _ -> False
  }
}
