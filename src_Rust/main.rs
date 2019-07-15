use in_out::{read_distance, read_points_coord, write_result, write_groups};
mod in_out;

use point::{cluster, sse};
mod point;

fn main() {
    let _dist = read_distance("distancia.txt".to_string());
    let mut points = read_points_coord("entrada.txt".to_string());

    let groups = cluster(&mut points, _dist);

    write_result("result.txt".to_string(), sse(&groups));
    write_groups("saida.txt".to_string(), groups);
}