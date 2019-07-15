import point as p

points = []

# Faz a leitura do arquivo das coordenadas dos pontos
# e insere cada ponto na lista de pontos.
with open("entrada.txt") as f:
    for i, line in enumerate(f, start = 1):
        points.append(p.Point([float(d) for d in line.split()], i))

# Faz a leitura do arquivo que contém a distância limite.
with open("distancia.txt") as f:
    distance = float(f.readline().strip())

groups = p.cluster(points, distance)

# Cria o arquivo result.txt e escreve a SSE do agrupamento.
with open("result.txt","w") as f:
    f.write("{0:.4f}".format(p.sse(groups)))

# Cria o arquivo saida.txt e escreve os grupos formados no agrupamento.
with open("saida.txt","w") as f:
    f.write("\n\n".join(" ".join(map(str,g)) for g in groups))