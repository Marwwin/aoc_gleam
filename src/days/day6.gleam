import gleam/io
import gleam/dict.{type Dict}
import gleam/string
import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}

pub fn part1(input: String) {
  string.trim(input)
  |> string.split("\t")
  |> list.map(int.parse)
  |> result.values()
  |> walk(set.new(), 0)
  ""
}

pub fn part2(input: String) {
  12 / 10
  |> int.to_string
}

fn walk(bank: List(Int), visited: Set(List(Int)), cycles: Int) {
  io.debug(cycles)
  io.debug(set.contains(visited, bank))
  case set.contains(visited, bank) {
    True -> cycles
    False -> {
      set.insert(visited, bank)
      let max = list.fold(bank, 0, int.max)
      let index =
        list.fold_until(bank, 0, fn(acc, v) {
          case v == max {
            True -> list.Stop(acc)
            False -> list.Continue(acc + 1)
          }
        })
      let bank_length = list.length(bank)
      let to_all = max / bank_length
      let rem = max % bank_length
      let offset_right = int.min(bank_length - index - 1, rem)
      let offset_left = int.max(0, rem - offset_right)
      //      io.println(
      //        "Value: "
      //        <> int.to_string(max)
      //        <> "\n Length of Bank: "
      //        <> int.to_string(bank_length)
      //        <> "\n Dist to all: "
      //        <> int.to_string(to_all)
      //        <> "\n Remainder: "
      //        <> int.to_string(rem)
      //        <> "\n index: "
      //        <> int.to_string(index)
      //        <> "\n Right: "
      //        <> int.to_string(offset_right)
      //        <> "\n Left: "
      //        <> int.to_string(offset_left),
      //      )
      let to_right = index + offset_right
      let new_bank =
        list.index_map(bank, fn(block, i) {
          case i {
            n if n == index -> 0 + to_all
            n if n < offset_left -> block + 1 + to_all
            n if n > index && n <= to_right -> block + 1 + to_all
            _ -> block + to_all
          }
        })
      walk(new_bank, visited, cycles + 1)
    }
  }
}

fn add(block: Int, n: Int) {
  block + n
}
