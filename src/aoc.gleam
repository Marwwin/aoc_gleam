import gleam/io
import simplifile

import days/day1
import days/day2
import days/day3
import days/day4

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

  let day3_input = 265149
  io.println("Day 3")
  io.println("  Part 1: " <> day3.part1(day3_input))
  io.println("  Part 2: " <> day3.part2(day3_input))

  let day4_input_file = "./src/days/day4_input"
  let assert Ok(day4_input) = simplifile.read(day4_input_file)
  io.println("Day 4")
  io.println("  Part 1: " <> day4.part1(day4_input))
  io.println("  Part 2: " <> day4.part2(day4_input))


}
