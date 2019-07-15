package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// Faz a leitura do arquivo das coordenadas dos pontos
// e retorna o conjunto de pontos
func readFileOfPointsCoord(fileName string) Group {
	var X Group // Conjunto de pontos

	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var line int32 = 1
	for scanner.Scan() { // Faz a leitura de todas as linhas do arquivo

		// Cada linha é representada por uma string.
		// Essa string é dividida pelos espaços em substrings.
		// Para cada substring, é feita a conversão para float64 e essa coordenada
		// é adicionada a um Point
		var p Point
		p.line = line
		for _, s := range strings.Split(scanner.Text(), " ") {
			f, err := strconv.ParseFloat(s, 64)
			if err == nil {
				p.coord = append(p.coord, f)
			} else {
				panic(err)
			}
		}

		X = append(X, p)
		line++
	}
	return X
}

// Faz a leitura do arquivo que contém a distância limite
func readFileOfDistance(fileName string) float64 {
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()

	t, err := strconv.ParseFloat(scanner.Text(), 64)
	if err != nil {
		panic(err)
	}
	return t
}

// Cria um arquivo e escreve a SSE do agrupamento
func writeResultFile(fileName string, sse float64) {
	file, err := os.Create(fileName)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	fmt.Fprintf(file, "%.4f", sse)
}

// Cria um arquivo e escreve os grupos formados no agrupamento
func writeGroupsFile(fileName string, C []Group) {
	file, err := os.Create(fileName)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	for i, group := range C {
		fmt.Fprintf(file, "%v", groupToString(group))
		if i < (len(C)-1) {
			fmt.Fprintf(file, "\n\n")
		}
	}
}
