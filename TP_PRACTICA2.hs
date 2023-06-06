-- TP "CARRERAS" -- 

------------------------------------------------------------------------------------------------------------
type Carrera     = [Auto]
type Tiempo      = Int
type Color       = String
type Modificador = (Int -> Int)
type PowerUps    = Carrera -> Carrera

data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distanciaRecorrida :: Int
} deriving (Show, Eq)

------------------------------------------------------------------------------------------------------------

ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) =
    (ordenarSegun criterio . filter (not . criterio x)) xs ++ [x] ++
       (ordenarSegun criterio . filter (criterio x)) xs

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
  = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

------------------------------------------------------------------------------------------------------------
hamilton   = Auto  "Gris" 300 100
verstappen = Auto  "Azul" 300 095
leclerc    = Auto  "Rojo" 300 090
bottas     = Auto  "Blanco" 300 085
alonso     = Auto  "Verde"  300 080

a = [terremoto leclerc carrera]
b = [terremoto bottas carrera]
c = [miguelitos 55 hamilton carrera]
d = [miguelitos 32 alonso carrera]
------------------------------------------------------------------------------------------------------------
carrera  = [hamilton,alonso,leclerc,bottas,alonso]
pw       = [a,d]
------------------------------------------------------------------------------------------------------------

---PUNTO 1---------------------------------------------------------------------------------------------------------

estadoActualCarrera :: Carrera -> Carrera
estadoActualCarrera = ordenarSegun (\x y -> distanciaRecorrida x > distanciaRecorrida y)

estaCerca :: Auto -> Auto -> Bool
estaCerca autoA autoB = autoA /= autoB && abs (distanciaRecorrida autoA - distanciaRecorrida autoB) <10

vaTranquilo :: Carrera -> Auto -> Bool
vaTranquilo carrera auto = (auto == head (estadoActualCarrera carrera)) && not (estaCerca auto ((!!) carrera 1))

estaAdelante :: Auto -> Auto -> Bool
estaAdelante autoA autoB = distanciaRecorrida autoA > distanciaRecorrida autoB

cuantosAutosAtras :: Carrera -> Auto -> Int
cuantosAutosAtras carrera auto = length ((filter (estaAdelante auto) carrera))

puesto :: Carrera -> Auto -> Int
puesto carrera auto = abs ((cuantosAutosAtras carrera auto) - length carrera)

---PUNTO 2---------------------------------------------------------------------------------------------------------

corra :: Auto -> Tiempo -> Auto
corra (Auto color velocidad distanciaRecorrida) tiempo = Auto color velocidad (distanciaRecorrida + tiempo * velocidad)

alterarVelocidad :: Modificador -> Auto -> Auto
alterarVelocidad modificador auto = auto {velocidad = modificador (velocidad auto)}

bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad cantidad = alterarVelocidad (max 0 . subtract cantidad)

---PUNTO 3---------------------------------------------------------------------------------------------------------

terremoto :: Auto -> PowerUps
terremoto auto carrera = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad (50)) carrera

miguelitos :: Int -> Auto -> PowerUps
miguelitos cantidad auto carrera = afectarALosQueCumplen (estaAdelante auto) (bajarVelocidad (cantidad)) carrera

--activarPoderJetpack :: Auto -> Tiempo -> Auto
activarPoderJetpack auto tiempo = undefined -- fold??¡¿¿

jetPack :: Tiempo -> Auto -> PowerUps
jetPack tiempo auto carrera = afectarALosQueCumplen (==auto) (activarPoderJetpack auto) carrera

---PUNTO 4---------------------------------------------------------------------------------------------------------

correnTodos :: Carrera -> Tiempo -> Carrera
correnTodos carrera tiempo = afectarALosQueCumplen (\x -> x==x) (flip corra tiempo) carrera 

colorIgual :: Color -> Auto -> Bool
colorIgual color1 auto = (color1 == color auto)

usaPowerUp :: PowerUps -> Color -> Auto
usaPowerUp powerUp color = head (filter (colorIgual color) (estadoActualCarrera carrera))

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, String)]
simularCarrera carrera powerUps = foldl (\res powerUp -> res ++ estadoFinalCarrera powerUp carrera) [(0, color (head carrera))] powerUps

estadoFinalCarrera :: (Carrera -> Carrera) -> Carrera -> [(Int, String)]
estadoFinalCarrera powerUp carrera = foldl (\res auto -> res ++ [(distanciaRecorrida auto, color auto)]) [] (estadoActualCarrera (powerUp carrera))