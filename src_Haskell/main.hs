import Data.List
import Text.Printf
type Point = ([Double], Int)
type Group = [Point]

main :: IO ()
main = do
    points   <- readPointsCoord
    distance <- readDistance
    let groups = cluster points distance
    writeFile "saida.txt"  $ displayGroups groups
    writeFile "result.txt" $ printf "%.4f" $ sse groups

-- Realiza o algoritmo de agrupamento e retorna uma lista com todos os grupos.
cluster :: [Point] -> Double -> [Group]
cluster points dist
    | points == [] = []
    | otherwise = [[leader] ++ group] ++ cluster otherPoints dist
        where
            leader = head points
            checkDistance d xs ys = euclideanDistance (fst xs) (fst ys) <= d
            (group, otherPoints) = partition (checkDistance dist leader) (tail points)

-- Calcula a soma das distâncias euclidianas quadradas (SSE) entre os pontos
-- pertencentes a cada um dos grupos.
sse :: [Group] -> Double
sse groups = sum [ sseGroup x | x <- groups]

-- Calcula a soma das distâncias euclidianas quadradas dos pontos ao centróide do grupo.
sseGroup :: Group -> Double
sseGroup group = sum [ (euclideanDistance coord c)^2 | (coord,i) <- group]
    where
        c = centroid group

-- Retorna o ponto que representa o centróide de um grupo.
centroid :: Group -> [Double]
centroid group = map (/fromIntegral(length group)) $ sumByIndex $ map fst group

-- Calcula a Distância Euclidiana entre dois pontos.
euclideanDistance :: [Double] -> [Double] -> Double
euclideanDistance xs ys = sqrt $ sum $ map (^2) $ zipWith (-) xs ys

-- Retorna a string que representa um grupo.
displayGroup :: Group -> String
displayGroup group = unwords [ show line | (coord,line) <- group]

-- Retorna uma strings que representa todos os grupos.
displayGroups :: [Group] -> String
displayGroups groups = intercalate "\n\n" $ map displayGroup groups

-- Converte uma lista de strings para uma lista de Double.
-- OBS: Os caracteres das strings devem ser números para a conversão funcionar.
strListToDoubleList :: [String] -> [Double]
strListToDoubleList = map read

-- Converte a lista de coord. de pontos, representada por lista de strings,
-- em uma lista de coord. de pontos representada por lista de listas de Double.
getCoordList :: [String] -> [[Double]]
getCoordList points = map strListToDoubleList $ map words points

-- Realiza o somatório (por posição) dos valores das listas de xss e retorna
-- uma lista contendo o resultado da soma correspondente a cada posição.
sumByIndex :: [[Double]] -> [Double]
sumByIndex xss = map sum $ transpose xss

-- Realiza a leitura do arquivo das coordenadas dos pontos e retorna a lista de pontos.
readPointsCoord :: IO [Point]
readPointsCoord = do 
    file <- readFile "entrada.txt"
    let coord = getCoordList $ lines file
    return (zip coord [1..length coord]) -- Associa cada coordenada a um índice numa tupla.

-- Realiza a leitura do arquivo que contém a distância limite.
readDistance :: IO (Double)
readDistance = do
    file <- readFile "distancia.txt"
    return (read file::Double)