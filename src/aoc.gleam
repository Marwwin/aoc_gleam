import gleam/io
import simplifile

import days/day1
import days/day2

pub fn main() {
  let day1_input_file = "./src/days/day1_input"
  let assert Ok(day1_input) = simplifile.read(day1_input_file)
  io.println("Day 1")
  io.println("  Part 1: " <> day1.part1(day1_input))
  io.println("  Part 2: " <> day1.part2(day1_input))

  let day2_input_file = "./src/days/day2_input"
  let assert Ok(day2_input) = simplifile.read(day2_input_file)
  io.println("Day 2")
  io.println("  Part 1: " <> day2.part1(day2_input))
  io.println("  Part 2: " <> day2.part2(day2_input))
}
