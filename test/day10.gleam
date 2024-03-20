import gleeunit
import gleeunit/should
import days/day10

pub fn main() {
  gleeunit.main()
}

pub fn day10_test() {
  day10.part2("")
  |> should.equal("a2582a3a0e66e6e86e3812dcb672a272")

  day10.part2("AoC 2017")
  |> should.equal("33efeb34ea91902bb2f59c9920caa6cd")

  day10.part2("1,2,3")
  |> should.equal("3efbe78a8d82f29979031a4aa0b16a9d")

  day10.part2("1,2,4")
  |> should.equal("63960835bcdc130f0b66d7ff4f6a5a8e")
}
