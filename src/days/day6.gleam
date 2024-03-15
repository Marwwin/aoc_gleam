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
  |> result.values
  |> walk(dict.new(), 0)
  |> int.to_string
}

pub fn part2(input: String) {
  let inp =
    string.trim(input)
    |> string.split("\t")
    |> list.map(int.parse)
    |> result.values

  let p1 = walk(inp, dict.new(), 0)
  let p2 = walk2(inp, dict.new(), 0)
  p2 - p1
  |> int.to_string
}

fn walk(bank: List(Int), visited: Dict(List(Int), Int), cycles: Int) {
  case dict.get(visited, bank) {
    Ok(v) -> cycles
    _ -> {
      let visited = dict.insert(visited, bank, 1)
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

fn walk2(bank: List(Int), visited: Dict(List(Int), Int), cycles: Int) {
  let v = result.unwrap(dict.get(visited, bank), 0)
  case v {
    2 -> cycles
    _ -> {
      let visited = dict.insert(visited, bank, v + 1)
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
      walk2(new_bank, visited, cycles + 1)
    }
  }
}

fn add(block: Int, n: Int) {
  block + n
}
