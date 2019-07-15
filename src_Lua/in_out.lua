t = {}

-- Faz a leitura do arquivo que contém a distância limite.
function t.readFileOfDistance(fileName)
    file = io.open(fileName,"r")
    distance = file:read("*n")
    file:close(file)
    return distance
end

-- Faz a leitura do arquivo das coordenadas dos pontos
-- e retorna o conjunto de pontos.
function t.readFileOfPointsCoord(fileName)
    X = {} -- Conjunto de pontos.
    i = 1  -- Índice da linha do arquivo que representa o ponto.
    for line in io.lines(fileName) do
        p = {}
        p.coord = {}
        p.line = i
        for n in string.gmatch(line,"[^ ]+") do
            table.insert(p.coord, tonumber(n))
        end
        table.insert(X,p)
        i = i+1
    end
    return X
end

-- Cria um arquivo e escreve a SSE do agrupamento.
function t.writeResultFile(fileName, sse)
    file = io.open(fileName,"w")
    file:write(string.format("%.4f", sse))
    file:close(file)
end

-- Cria um arquivo e escreve os grupos formados no agrupamento.
function t.writeGroupsFile(fileName, C)
    file = io.open(fileName,"w")
    
    for i,group in pairs(C) do
        for k,v in pairs(group) do
            file:write(v.line)
            if k ~= (#group) then
                file:write(" ")
            end
        end
        if i ~= #C then
            file:write("\n\n")
        end
    end
end

return t