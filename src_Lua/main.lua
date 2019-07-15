local in_out = require("in_out")
local point  = require("point")

X = in_out.readFileOfPointsCoord("entrada.txt") -- Leitura do conjunto de pontos.
t = in_out.readFileOfDistance("distancia.txt")  -- Leitura da distância limite.
C = point.cluster(X, t) -- Executa o algoritmo de agrupamento e retorna o conjunto de grupos.

in_out.writeResultFile("result.txt", point.sse(C)) -- Escreve no arquivo "result.txt" a SSE.
in_out.writeGroupsFile("saida.txt", C) -- Escreve no arquivo "saida.txt" o conjunto de grupos.