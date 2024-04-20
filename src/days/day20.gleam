import gleam/list
import gleam/io
import gleam/result
import gleam/int
import gleam/string
import gleam/order.{Eq, Gt, Lt}

pub type Points {
  Point3D(x: Int, y: Int, z: Int)
}

pub type Particle {
  Particle(id: String, position: Points, velocity: Points, acceleration: Points)
}

pub fn solution(input: String) {
  let pased =
    input
    |> string.trim
    |> string.split("\n")
    |> list.index_map(fn(a, i) { parse(a, int.to_string(i)) })

    print("heppp")
  #("Day20", part1(pased), part2(pased))
}

fn part1(data: List(Particle)) {
    io.debug("hepppp")
  data
  |> list.filter(fn(particle) { abs(particle.acceleration) == 0 })
  |> list.sort(fn(a, b) {
    case abs(a.velocity) - abs(b.velocity) {
      0 -> Eq
      n if n < 0 -> Lt
      n if n > 0 -> Gt
      _ -> Eq
    }
  })
  |> list.first
  |> result.map(fn(r) { r.id })
  |> result.unwrap("")
}

fn part2(data: List(Particle)) {
    io.debug("hepp")
  count(data)
  |> io.debug
    "hepp"
}

fn count(data) {
  data
  |> list.map(apply_acceleration)
  |> list.filter(fn(p) { is_pos(p, data) })
}

fn is_pos(p, ps) {
  case ps {
    [a, ..rest] if a.pos == p.pos -> False
    [a, ..rest] if a.id == p.id -> True
    [_, ..rest] -> is_pos(p, rest)
    [] -> True
  }
}

fn apply_acceleration(p: Particle) {
  let Particle(pos, vec, acc) = p
  Particle(pos, add(vec, acc), vec)
}

fn add(p1: Point3D, p2: Point3D) {
  let Point3D(x1, y1, z1) = p1
  let Point3D(x2, y2, z2) = p2
  Point3D(x1 + x2, y1 + y2, z1 + z2)
}

fn parse(str, i) {
  case string.split(str, ">, ") {
    ["p=<" <> pos, "v=<" <> vel, "a=<" <> acc] ->
      Particle(
        id: i,
        position: to_3d(pos),
        velocity: to_3d(vel),
        acceleration: to_3d(acc),
      )
    _ -> panic as "oops"
  }
}

fn to_3d(pos) {
  case string.split(pos, ",") {
    [a, b, c] ->
      Point3D(
        int.parse(a)
          |> result.unwrap(0),
        int.parse(b)
          |> result.unwrap(0),
        int.parse(c)
          |> result.unwrap(0),
      )
    _ -> panic as "not supported"
  }
}

fn abs(p) {
  let Point3D(x, y, z) = p
  int.absolute_value(x) + int.absolute_value(y) + int.absolute_value(z)
}
// fn get_top_acceleration(particles: List(Particle), result) {
//   case particles {
//     [Particle(id, _, _, Point3D(x, y, z)), ..rest] -> get_top_acceleration(particles, sum)
//   }
// }
