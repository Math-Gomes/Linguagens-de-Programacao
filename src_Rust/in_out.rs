use std::io::{BufRead, BufReader, BufWriter, Write};
use std::fs::File;
use std::fs;

use point::{Point, Group, display_groups};

// Faz a leitura do arquivo que contém a distância limite.
pub fn read_distance(f: String) -> f64 {
    let reader = fs::read_to_string(f).expect("Erro na abertura do arquivo da distancia.");
    return reader.trim().parse::<f64>().unwrap();
}

// Faz a leitura do arquivo das coordenadas dos pontos e retorna o vetor de pontos.
pub fn read_points_coord(f: String) -> Vec<Point> {
    let reader = BufReader::new(File::open(f).expect("Erro na abertura do arquivo das coordenadas de pontos."));

    let mut points: Vec<Point> = Vec::new();

    for (i,cds) in reader.lines().enumerate() {
        let mut coords: Vec<f64> = Vec::new();
        for c in cds.unwrap().split_whitespace() {
            coords.push(c.parse::<f64>().unwrap());
        }
        points.push(Point{coord: coords, line: (i+1) as i32});
    } 
    return points;
}

// Cria um arquivo e escreve a SSE do agrupamento.
pub fn write_result(f: String, sse: f64) {
    let mut writer = BufWriter::new(File::create(f).expect("Erro ao criar o arquivo result.txt"));
    write!(writer, "{:.4}", sse).unwrap();
}

// Cria um arquivo e escreve os grupos formados no agrupamento.
pub fn write_groups(f: String, groups: Vec<Group>) {
    let mut writer = BufWriter::new(File::create(f).expect("Erro ao criar o arquivo saida.txt"));
    write!(writer, "{}", display_groups(&groups)).unwrap();
}