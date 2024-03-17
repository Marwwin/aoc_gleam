import gleeunit
import gleeunit/should
import days/day9

pub fn main() {
  gleeunit.main()
}

//pub fn part1_test() {
//  day9.part1("{}")
//  |> should.equal("1")
//
//  day9.part1("{{{}}}")
//  |> should.equal("6")
//
//  day9.part1("{{},{}}")
//  |> should.equal("5")
//
//  day9.part1("{{{},{},{{}}}}")
//  |> should.equal("16")
//
//  day9.part1("{<a>,<a>,<a>,<a>}")
//  |> should.equal("1")
//  day9.part1("{{<ab>},{<ab>},{<ab>},{<ab>}}")
//  |> should.equal("9")
//  day9.part1("{{<!!>},{<!!>},{<!!>},{<!!>}}")
//  |> should.equal("9")
//}

pub fn part1_fail_test() {
  day9.part1("{{<a!>},{<a!>},{<a!>},{<ab>}}")
  |> should.equal("3")
}
