import gleam/list
import gleam/set
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
  let particles =
    input
    |> string.trim
    |> string.split("\n")
    |> list.index_map(parse)

  #("Day20", part1(particles), part2(particles))
}

fn part1(particles: List(Particle)) {
  particles
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
  |> result.map(fn(particle) { particle.id })
  |> result.unwrap("")
}

fn abs(point: Points) {
  case point {
    Point3D(x, y, z) ->
      int.absolute_value(x) + int.absolute_value(y) + int.absolute_value(z)
  }
}

fn part2(data: List(Particle)) {
  do_part2(data, 0)
  |> list.length
  |> int.to_string
}

fn do_part2(particles: List(Particle), i) {
  case i {
    n if n > 1000 -> particles
    _ -> {
      let duplicates = find_duplicate_positions(particles, set.new(), set.new())
      particles
      |> list.filter(fn(p) { !set.contains(duplicates, p.position) })
      |> list.map(move_particle)
      |> do_part2(i + 1)
    }
  }
}

fn find_duplicate_positions(particles, seen, result) {
  case particles {
    [] -> result
    [Particle(_, pos, _, _), ..rest] -> {
      case set.contains(seen, pos) {
        True -> find_duplicate_positions(rest, seen, set.insert(result, pos))
        False -> find_duplicate_positions(rest, set.insert(seen, pos), result)
      }
    }
  }
}

fn move_particle(particle: Particle) {
  case particle {
    Particle(id, pos, vec, acc) -> {
      let new_vec = add(vec, acc)
      Particle(id, add(pos, new_vec), new_vec, acc)
    }
  }
}

fn add(p1: Points, p2: Points) {
  case p1, p2 {
    Point3D(x1, y1, z1), Point3D(x2, y2, z2) ->
      Point3D(x1 + x2, y1 + y2, z1 + z2)
  }
}

fn parse(str, i) {
  case string.split(str, ">, ") {
    ["p=<" <> pos, "v=<" <> vel, "a=<" <> acc] ->
      Particle(
        id: int.to_string(i),
        position: to_3d(pos),
        velocity: to_3d(vel),
        acceleration: to_3d(
          acc
          |> string.drop_right(1),
        ),
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
