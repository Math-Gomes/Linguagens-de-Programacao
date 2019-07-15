from math import sqrt

class Point:
    def __init__(self, coord, line):
        self.coord = coord
        self.line = line

    # Retorna a string que representa este ponto.
    def __repr__(self):
        return "{0}".format(self.line)

    # Calcula a Distância Euclidiana entre dois pontos.
    def euclideanDistance(self, p):
        return sqrt(sum([((x-y) ** 2) for (x,y) in zip(self.coord, p.coord)]))

    # Realiza a soma (por posição) das coordenadas de dois pontos.
    def sumCoords(self, p):
        return [sum(c) for c in zip(*[self.coord, p.coord])]

# Retorna o líder de um grupo de pontos.
def leader(group): return group[0]

# Particiona os pontos em duas listas: group e otherPoints.
# group contém os pontos cuja dist. Euclidiana do ponto
# ao líder do grupo <= dist. limite.
# otherPoints contém os pontos que não atendem a condição.
def partition(points, dist):
    if points == []: return []
    group, otherPoints = [points[0]], []
    for p in points[1:]:
        (group if (leader(group).euclideanDistance(p) <= dist) else otherPoints).append(p)
    return group, otherPoints

# Realiza o algoritmo de agrupamento e
# retorna uma lista com todos os grupos.
def cluster(points, dist):
    if(points == []): return []
    group,otherPoints = partition(points, dist)
    return [group] + cluster(otherPoints, dist)

# Calcula e retorna o ponto que
# representa o centróide de um grupo.
def centroid(group):
    centr = Point( [0]*len(group[0].coord) , -1)
    for p in group: centr.coord = centr.sumCoords(p)
    centr.coord = [c/len(group) for c in centr.coord]
    return centr

# Calcula a soma das distâncias euclidianas quadradas (SSE)
# entre os pontos pertencentes a cada um dos grupos.
def sse(groups):
    s = 0
    for group in groups:
        c = centroid(group)
        s += sum([point.euclideanDistance(c) ** 2 for point in group])
    return s