package main

import (
	"fmt"
	"math"
)

// Point representa um ponto no espaço.
type Point struct {
	coord []float64 // Vetor de coordenadas do ponto.
	line  int32     // Linha em que se encontram as coord. do ponto no arquivo de entrada
}

// Group representa um grupo de pontos.
type Group []Point

// Stringer de um ponto.
func (p Point) String() string {
	return fmt.Sprintf("%v", p.line)
}

// Cria e retorna uma string representando um grupo.
func groupToString(g Group) string {
	s := fmt.Sprintf("%v", g)
	return s[1 : len(s)-1]
}

// Calcula a Distância Euclidiana entre dois pontos.
func euclideanDistance(x Point, y Point) float64 {
	var sum float64
	for i := 0; i < len(x.coord); i++ {
		sum = sum + math.Pow((x.coord[i]-y.coord[i]), 2)
	}
	return math.Sqrt(sum)
}

// Retorna o líder de um grupo.
func getGroupLeader(G Group) Point {
	return G[0]
}

// Realiza o algoritmo de agrupamento e retorna o conjunto com todos os grupos.
func cluster(X Group, t float64) (C []Group) {
	// X é o grupo que contém todos os pontos
	// t é a distância limite
	// C é o conjunto de grupos
	for _, d := range X {
		leader := true
		for i := 0; i < len(C); i++ {
			if euclideanDistance(getGroupLeader(C[i]), d) <= t {
				C[i] = append(C[i], d)
				leader = false
				break
			}
		}
		if leader {
			C = append(C, Group{d})
		}
	}
	return C
}

// Calcula e retorna o ponto que representa o centróide de um grupo
func centroid(group Group) Point {
	nCoord := len(group[0].coord)  // Número de coordenadas de um ponto
	nPoints := float64(len(group)) // Número de pontos pertencentes ao grupo
	c := make([]float64, nCoord)   // Ponto que representa o centróide do grupo

	for i := 0; i < nCoord; i++ {
		for j := 0; j < len(group); j++ {
			// Realiza o somatório coordenada a coordenada dos pontos do grupo
			c[i] = c[i] + group[j].coord[i]
		}
		// Divide cada coordenada do centróide pelo total de pontos pertencentes ao grupo
		c[i] = c[i] / nPoints
	}

	return Point{c, 0}
}

// Calcula a soma das distâncias euclidianas quadradas (SSE) entre os pontos
// pertencentes a cada um dos grupos.
func sse(C []Group) float64 {
	var sum float64

	// Para cada grupo do conjunto de grupos (C), calcula-se seu respectivo
	// centróide e logo após é acumulado em sum o valor da dist. Euclidiana
	// quadrada entre cada ponto do grupo ao centróide.
	for _, group := range C {
		centr := centroid(group)
		for _, p := range group {
			sum = sum + math.Pow(euclideanDistance(p, centr), 2)
		}
	}
	return sum
}
