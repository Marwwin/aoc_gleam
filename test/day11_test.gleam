import gleeunit
import gleeunit/should
import days/day11

pub fn main() {
  gleeunit.main()
}

pub fn basic_steps_test() {
  day11.part1(["ne", "ne", "ne"])
  |> should.equal("3")

  day11.part1(["ne", "ne", "se", "se"])
  |> should.equal("0")

  day11.part1(["ne", "ne", "s", "s"])
  |> should.equal("2")
  day11.part1(["se", "sw", "se", "sw","sw"])
  |> should.equal("2")

}
