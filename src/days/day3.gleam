pub fn part1(input: Int) -> String {
  ""
}

pub fn part2(input: Int) -> String {
  ""
}

fn get_higher(n: Int) -> Int {
  get_higher_helper(n, 1, 0)
}

fn get_higher_helper(goal: Int, val: Int, level: Int) {
  let x = val + 8 * level
  case x {
    n if n >= goal -> x
    n -> get_higher_helper(goal, n, level + 1)
  }
}
