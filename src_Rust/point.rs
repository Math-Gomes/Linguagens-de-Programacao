pub struct Point {
    pub coord: Vec<f64>,
    pub line:  i32,
}

pub type Group = Vec<Point>;

// Implementa a função de display para um Point.
impl std::fmt::Display for Point {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}", self.line)
    }
}

// Retorna uma string que representa todos os grupos.
pub fn display_groups(gs: &Vec<Group>) -> String {
    let groups_str: Vec<_> = gs.iter().map(display_group).collect();
    return groups_str.join("\n\n");
}

// Retorna a string que representa um grupo.
fn display_group(g: &Group) -> String {
    let group_str: Vec<String> = g.iter().map(ToString::to_string).collect();
    return group_str.join(" ");
}

// Calcula a Distância Euclidiana entre dois pontos.
fn euclidean_distance(x: &Point, y: &Point) -> f64 {
    let mut sum = 0.0;
    for (p,q) in (x.coord).iter().zip((y.coord).iter()) {
        sum += (p-q).powf(2.0);
    }
    return sum.sqrt();
}

// Cria um grupo com os pontos cuja dist. Euclidiana do ponto
// ao líder do grupo <= dist. limite.
fn partition(points: &mut Vec<Point>, _dist: f64) -> Group {
    if points.is_empty() {
        return Vec::new();
    }
    let mut group: Group = vec![points.remove(0)];
    let old_len = points.len();
    let mut fst = 0;
    for _ in 0..old_len {
        if euclidean_distance(&group[0], &points[fst]) <= _dist {
            group.push(points.remove(fst));
        } else {
            fst += 1;
        }
    }
    return group;
}

// Realiza o algoritmo de agrupamento e retorna um vetor com todos os grupos.
pub fn cluster(mut points: &mut Vec<Point>, _dist: f64) -> Vec<Group> {
    if points.is_empty() {
        return vec![vec![]];
    }
    let mut gs: Vec<Group> = Vec::new();
    while !points.is_empty() {
        gs.push(partition(&mut points, _dist));
    }
    return gs;
}

// Retorna o ponto que representa o centróide de um grupo.
fn centroid(group: &Group) -> Point {
    let n_coords = group[0].coord.len();
    let n_points = group.len();
    let mut c: Vec<f64> = vec![0.0; n_coords]; // Inicializa o centróide.
    for i in 0..n_coords {
        for p in group {
            c[i] += p.coord[i];
        }
        c[i] /= n_points as f64;
    }
    return Point { coord: c, line: -1 };  
}

// Calcula a soma das distâncias euclidianas quadradas (SSE) entre os pontos pertencentes a cada um dos grupos.
pub fn sse(groups: &Vec<Group>) -> f64 {
    let mut sum = 0.0;
    for g in groups {
        let centr = centroid(g);
        for p in g {
            sum += euclidean_distance(&centr, p).powf(2.0);
        }
    }
    return sum;
}