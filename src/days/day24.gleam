import gleam/string
import gleam/pair
import gleam/int
import gleam/list

pub type Port {
  Port(id: Int, port1: Int, port2: Int)
}

pub fn solution(input: String) {
  let data =
    input
    |> string.trim
    |> string.split("\n")
    |> list.index_map(parse)
  #("Day 24", part1(data), part2(data))
}

fn part1(data: List(Port)) {
  do_part1(data, list.new(), 0, 0)
  |> int.to_string
}

fn do_part1(ports: List(Port), seen: List(Int), prev, result) {
  let possible =
    list.filter(ports, fn(e) {
      !list.contains(seen, e.id) && { e.port1 == prev || e.port2 == prev }
    })
  case possible {
    [] -> {
      result
    }
    _ ->
      list.map(possible, fn(e) {
        do_part1(ports, [e.id, ..seen], other(e, prev), sum(e) + result)
      })
      |> list.fold(0, fn(acc, e) {
        case e > acc {
          True -> e
          False -> acc
        }
      })
  }
}

fn part2(data) {
  do_part2(data, list.new(), 0, 0)
  |> pair.first
  |> int.to_string
}

fn do_part2(ports: List(Port), seen: List(Int), prev, result) {
  let possible =
    list.filter(ports, fn(e) {
      !list.contains(seen, e.id) && { e.port1 == prev || e.port2 == prev }
    })
  case possible {
    [] -> {
      #(result, list.length(seen))
    }
    _ ->
      list.map(possible, fn(e) {
        do_part2(ports, [e.id, ..seen], other(e, prev), sum(e) + result)
      })
      |> list.fold(#(0, 0), fn(acc: #(Int, Int), e: #(Int, Int)) {
        case acc, e {
          #(a_value, a_length), #(e_value, e_length) if e_length >= a_length ->
            case a_value >= e_value {
              True -> acc
              False -> e
            }
          _, _ -> acc
        }
      })
  }
}

fn other(p: Port, n: Int) {
  case p {
    Port(_, a, b) if a == n -> b
    Port(_, a, b) if b == n -> a
    _ -> panic as "other failed"
  }
}

fn sum(p: Port) {
  case p {
    Port(_, a, b) -> a + b
  }
}

fn parse(port: String, i: Int) {
  case string.split(port, "/") {
    [a, b] -> {
      let assert Ok(p1) = int.parse(a)
      let assert Ok(p2) = int.parse(b)
      Port(i, p1, p2)
    }
    _ -> panic as "error on input"
  }
}
