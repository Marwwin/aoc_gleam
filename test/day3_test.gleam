import gleeunit
import gleeunit/should
import days/day3

pub fn main() {
  gleeunit.main()
}

pub fn get_level_test() {
  day3.get_level(1)
  |> should.equal(0)

  day3.get_level(2)
  |> should.equal(1)
}

pub fn get_value_at_level_test() {
  day3.get_value_at_level(0)
  |> should.equal(1)

  day3.get_value_at_level(1)
  |> should.equal(9)

  day3.get_value_at_level(2)
  |> should.equal(25)
}

pub fn get_side_at_level_test() {
  day3.get_side_at_level(1)
  |> should.equal(1)

  day3.get_side_at_level(2)
  |> should.equal(3)

  day3.get_side_at_level(3)
  |> should.equal(5)
}
