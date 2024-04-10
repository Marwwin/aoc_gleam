import gleam/string
import gleam/int

const gen_a_factor = 16_807

const gen_b_factor = 48_271

const result_divisor = 2_147_483_647

pub fn solution(_input: String) {
  let a = 634
  let b = 301
  #("Day15", part1(40_000_000, a, b), part2(5_000_000, a, b))
}

pub fn part1(limit: Int, a, b) -> String {
  int.to_string(do_count(0, limit, a, generator_a, b, generator_b, 0))
}

pub fn part2(limit, a, b) {
  int.to_string(do_count(0, limit, a, next_a, b, next_b, 0))
}

pub fn do_count(i, limit, a, gen_a, b, gen_b, res) {
  case i < limit {
    True -> {
      let aa = gen_a(a)
      let bb = gen_b(b)
      case
        int.bitwise_exclusive_or(aa, bb)
        |> lower_16_bits_unset
      {
        True -> do_count(i + 1, limit, aa, gen_a, bb, gen_b, res + 1)
        False -> do_count(i + 1, limit, aa, gen_a, bb, gen_b, res)
      }
    }
    False -> res
  }
}

fn next_a(a) {
  let aa = generator_a(a)
  case aa % 4 {
    0 -> aa
    _ -> next_a(aa)
  }
}

fn next_b(b) {
  let bb = generator_b(b)
  case bb % 8 {
    0 -> bb
    _ -> next_b(bb)
  }
}

pub fn generator_a(a) {
  a * gen_a_factor % result_divisor
}

pub fn generator_b(b) {
  b * gen_b_factor % result_divisor
}

pub fn lower_16_bits_unset(n: Int) {
  n
  |> int.to_base16
  |> string.ends_with("0000")
}
