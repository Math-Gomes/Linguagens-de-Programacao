t = {}

-- Calcula a Distância Euclidiana entre dois pontos
local function euclideanDistance(x,y)
    local sum = 0
	for i = 1, #x do
		sum = sum + math.pow((x[i]-y[i]), 2)
    end
	return math.sqrt(sum)
end

-- Retorna o líder de um grupo.
local function getGroupLeader(group)
	return group[1]
end

-- Realiza o algoritmo de agrupamento e
-- retorna o conjunto com todos os grupos.
function t.cluster(X,t)
    -- X é o grupo que contém todos os pontos
	-- t é a distância limite
	-- C é o conjunto de grupos
	C = {}
	for _, point in pairs(X) do
        leader = true
		for _, group in pairs(C) do
			if euclideanDistance((getGroupLeader(group)).coord, point.coord) <= t then
				table.insert(group, point)
				leader = false
				break
            end
		end
		if leader then
			table.insert(C,{point})
        end
	end
	return C
end

-- Calcula e retorna o ponto que representa o centróide de um grupo
local function centroid(group)
	centr = {} -- Ponto que representa o centróide do grupo

	for i=1, #group[1].coord do
		centr[i] = 0
		for j=1, #group do
			-- Realiza o somatório coordenada a coordenada dos pontos do grupo
			centr[i] = centr[i] + group[j].coord[i]
		end
		-- Divide cada coordenada do centróide pelo total de pontos pertencentes ao grupo
		centr[i] = centr[i] / #group
	end

	return centr
end

-- Calcula a soma das distâncias euclidianas quadradas (SSE) entre os pontos
-- pertencentes a cada um dos grupos.
function t.sse(C)
	sum = 0
	-- Para cada grupo do conjunto de grupos (C), calcula-se seu respectivo
	-- centróide e logo após é acumulado em sum o valor da dist. Euclidiana
	-- quadrada de cada ponto do grupo ao centróide.
	for _, group in pairs(C) do
		centr = centroid(group)
		for _, point in pairs(group) do
			sum = sum + math.pow(euclideanDistance(point.coord, centr), 2)
		end
	end

	return sum
end

return t