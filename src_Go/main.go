package main

func main() {

	var X Group   // Grupo de pontos
	var C []Group // Conjunto de grupos
	var t float64 // Distância limite

	t = readFileOfDistance("distancia.txt")
	X = readFileOfPointsCoord("entrada.txt")
	C = cluster(X, t)

	writeResultFile("result.txt", sse(C))
	writeGroupsFile("saida.txt", C)
}
