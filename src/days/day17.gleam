import gleam/int
import gleam/io
import gleam/string
import gleam/list

pub fn solution(input: String) {
  let input = parse(input)
  #("Day 17", part1(input), part2(input))
}

fn part1(steps) {
  let state = walk(steps, [0], 2017)
  case list.at(state, 1) {
    Ok(n) -> n
    Error(_) -> panic("should not")
  }
  |> int.to_string
}

fn walk(steps, state: List(Int), limit) {
  case list.length(state) {
    i if i > limit -> state
    i -> {
      let pos = steps % i
      let res = list.split(state, pos + 1)
      let new_state = list.append([i, ..res.1], res.0)
      walk(steps, new_state, limit)
    }
  }
}

fn part2(steps) {
  do_part2(steps, 0, 0, 0, 0)
  |> int.to_string
}

fn do_part2(steps, i, pos, out, offset) {
  case i {
    i if i == 50_000_001 -> out
    _ -> {
      let new_pos = { { pos + steps } % i } + 1
      let new_out = case new_pos {
        p if p == 1 -> i
        _ -> out
      }
      do_part2(steps, i + 1, new_pos, new_out, offset)
    }
  }
}

fn parse(input: String) -> Int {
  case int.parse(string.trim(input)) {
    Ok(n) -> n
    Error(_) -> panic("Input not a number")
  }
}
