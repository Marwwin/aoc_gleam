import gleam/io
import gleam/int
import gleam/result
import gleam/list
import gleam/string
import gleam/pair
import utils

pub fn solution(input: String) {
  #("Day 10", part1(input), part2(input))
}

pub fn part1(input: String) {
  let result =
    string.trim(input)
    |> string.split(",")
    |> list.map(int.parse)
    |> result.values
    |> walk

  let knots = result.0
  let offset = result.1

  knots
  |> list.split(offset)
  |> pair.second
  |> list.split(2)
  |> pair.first
  |> utils.product
  |> int.to_string
}

pub fn part2(input: String) {
  let result =
    string.trim(input)
    |> string.split(",")
    |> string.join(",")
    |> string.to_utf_codepoints()
    |> list.append(
      list.map([17, 31, 73, 47, 23], fn(n) { string.utf_codepoint(n) })
      |> result.values(),
    )
    |> list.map(string.utf_codepoint_to_int)
    |> list.repeat(64)
    |> list.flatten
    |> walk

  let knots = result.0
  let offset = result.1

  let s = list.split(knots, offset)
  list.append(s.1, s.0)
  |> list.sized_chunk(16)
  |> list.map(fn(chunk) {
    list.fold(chunk, 0, fn(acc, e) { int.bitwise_exclusive_or(acc, e) })
  })
  |> list.map(int.to_base16)
  |> list.map(fn(n) { string.pad_left(n, 2, "0") })
  |> string.join("")
  |> string.lowercase
}

fn walk(lengths) -> #(List(Int), Int) {
  do_walk(list.range(0, 255), 0, 0, lengths)
}

fn do_walk(knots, pos, skip, lengths) {
  case lengths {
    [] -> {
      let offset = list.length(knots) - pos
      #(knots, offset)
    }
    [l, ..rest] -> {
      let n = l + skip
      let split = list.split(knots, l)
      let first_joined =
        list.append(
          pair.first(split)
            |> list.reverse,
          pair.second(split),
        )
      let second_split = list.split(first_joined, n % 256)

      do_walk(
        list.append(second_split.1, second_split.0),
        { pos + n } % 256,
        skip + 1,
        rest,
      )
    }
  }
}
