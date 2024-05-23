import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/string

pub type Pixel {
  Empty
  One
  Two
  Three
}

pub type Pattern {
  Pattern2
  Pattern3
}

pub type Grid {
    Grid(grid: String, size: Int)
}

pub fn solution(input: String) {
  let d = input
  |> string.trim
  |> string.split("\n")
  |> parse
  |> io.debug
  #("Day 21", part1(d), "")
}

fn part1(d){
    let start_grid = Grid(".#...####", 3) 
    print_grid(start_grid)
}

fn print_grid(g:Grid){
    split_str_by_length(g.grid,g.size)
    |> io.debug
}

fn split_str_by_length(str:String, length:Int){
   do_split_str_by_length(str,length,0,list.new()) 
}

fn do_split_str_by_length(str,length,i,res){
    case string.length(str){
        0 -> res
        _ -> {
            let a = string.slice(str,0,length)
            let rest = string.slice(str,length, string.length(str))
            do_split_str_by_length(rest,length, i, list. )}
    }
}


fn parse(input: List(String)) {
  let pattern_dict =
    dict.new()
    |> dict.insert(Pattern2, dict.new())
    |> dict.insert(Pattern3, dict.new())
  do_parse(input, pattern_dict)
}

fn do_parse(str: List(String), d) {
  case str {
    [] -> d
    [a, ..rest] -> {
      let assert [in, out] = string.split(a, " => ")
      case string.length(in) {
        5 -> {
          let assert Ok(p2_dict) = dict.get(d, Pattern2)
          do_parse(
            rest,
            dict.insert(d, Pattern2, dict.insert(p2_dict, in, out)),
          )
        }
        11 -> {
          let assert Ok(p2_dict) = dict.get(d, Pattern3)
          do_parse(
            rest,
            dict.insert(d, Pattern3, dict.insert(p2_dict, in, out)),
          )
        }
        _ -> panic as "Unknown pattern size in do_parse"
      }
    }
  }
}

