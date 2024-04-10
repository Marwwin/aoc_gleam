import gleam/io
import simplifile
import days/day1
import days/day2
import days/day3
import days/day4
// import days/day5
import days/day6
import days/day7
import days/day8
import days/day9
import days/day10
import days/day11
import days/day12
import days/day13
import days/day14
import days/day15

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

  let day3_input = 265_149
  io.println("Day 3")
  io.println("  Part 1: " <> day3.part1(day3_input))
  io.println("  Part 2: " <> day3.part2(day3_input))

  let day4_input_file = "./src/days/day4_input"
  let assert Ok(day4_input) = simplifile.read(day4_input_file)
  io.println("Day 4")
  io.println("  Part 1: " <> day4.part1(day4_input))
  io.println("  Part 2: " <> day4.part2(day4_input))

  // let day5_input_file = "./src/days/day5_input"
  // let assert Ok(day5_input) = simplifile.read(day5_input_file)
  // io.println("Day 5")
  //  io.println("  Part 1: " <> day5.part1(day5_input))
  //io.println("  Part 2: " <> day5.part2(day5_input))

  let day6_input_file = "./src/days/day6_input"
  let assert Ok(day6_input) = simplifile.read(day6_input_file)
  io.println("Day 6")
  io.println("  Part 1: " <> day6.part1(day6_input))
  io.println("  Part 2: " <> day6.part2(day6_input))

  let day7_input_file = "./src/days/day7_input"
  let assert Ok(day7_input) = simplifile.read(day7_input_file)
  show_result(day7.solution(day7_input))

  let day8_input_file = "./src/days/day8_input"
  let assert Ok(day8_input) = simplifile.read(day8_input_file)
  io.println("Day 8")
  io.println("  Part 1: " <> day8.part1(day8_input))
  io.println("  Part 2: " <> day8.part2(day8_input))

  let day9_input_file = "./src/days/day9_input"
  let assert Ok(day9_input) = simplifile.read(day9_input_file)
  io.println("Day 9")
  io.println("  Part 1: " <> day9.part1(day9_input))
  io.println("  Part 2: " <> day9.part2(day9_input))

  let day10_input_file = "./src/days/day10_input"
  let assert Ok(day10_input) = simplifile.read(day10_input_file)
  show_result(day10.solution(day10_input))

  let day11_input_file = "./src/days/day11_input"
  let assert Ok(day11_input) = simplifile.read(day11_input_file)
  show_result(day11.solution(day11_input))

  let day12_input_file = "./src/days/day12_input"
  let assert Ok(day12_input) = simplifile.read(day12_input_file)
  show_result(day12.solution(day12_input))

  let day13_input_file = "./src/days/day13_input"
  let assert Ok(day13_input) = simplifile.read(day13_input_file)
  show_result(day13.solution(day13_input))

  let day14_input_file = "./src/days/day14_input"
  let assert Ok(day14_input) = simplifile.read(day14_input_file)
  show_result(day14.solution(day14_input))
    
  let day15_input_file = "./src/days/day15_input"
  let assert Ok(day15_input) = simplifile.read(day15_input_file)
  show_result(day15.solution(day15_input))
}

pub fn show_result(result: #(String, String, String)) {
  io.println(result.0)
  io.println("  Part 1: " <> result.1)
  io.println("  Part 2: " <> result.2)
}
