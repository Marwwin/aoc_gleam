import gleam/io
import gleam/dict
import gleam/string
import gleam/int
import gleam/list
import gleam/result
import gleam/set

type Block =
  Int

type Bank =
  List(Block)

pub fn part1(input: String) {
  string.trim(input)
  |> string.split("\t")
  |> list.map(int.parse)
  |> result.values()
  |> io.debug()

  ""
}

pub fn part2(input: String) {
  todo
}

fn walk(bank: List(Int), visited) {
  let max = list.fold(bank, 0, int.max)
  let index =
    list.fold_until(bank, 0, fn(acc, v) {
      case v == max {
        True -> list.Stop(acc)
        False -> list.Continue(acc + 1)
      }
    })
    let offset = list.length(bank)
    let to_all = max / offset
    let 
}

fn add(block: Int, n: Int) {
  block + n
}
