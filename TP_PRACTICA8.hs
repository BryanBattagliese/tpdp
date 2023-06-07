module Lib where
import Text.Show.Functions

-- Modelo inicial

data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)
tir1 = UnTiro    10 95 0
obs  = [tunelRampita,tunelRampita,hoyo]


data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

--------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 1 --

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = UnTiro {
    velocidad = 10, 
    precision = precisionJugador habilidad* 2, 
    altura = 0 }

madera :: Palo
madera habilidad = UnTiro {
    velocidad = 100,
    precision = div (precisionJugador habilidad) 2,
    altura = 5 }

hierros :: Int -> Palo
hierros n habilidad = UnTiro {
    velocidad = fuerzaJugador habilidad* n,
    precision = div (precisionJugador habilidad) n,
    altura    = (n-3) `max` 0
}

palos :: [Palo]
palos =  [putter, madera] ++ map hierros [1..10]

--------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 2 --

golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo $ habilidad jugador

--------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 3 --

data Obstaculo = UnObstaculo {
  puedeSuperar :: Tiro -> Bool,
  efectoLuegoDeSuperar :: Tiro -> Tiro
}

tiroDetenido :: Tiro -> Tiro
tiroDetenido tiro = UnTiro {velocidad = 0, precision = 0, altura = 0}
--------------------------------------------------------------------------------------------------------------------------------

tunelRampita :: Obstaculo
tunelRampita = UnObstaculo tiroSuperaTunelRampita efectoTunelRampita

tiroSuperaTunelRampita :: Tiro -> Bool
tiroSuperaTunelRampita tiro = (precision tiro > 90) && (altura tiro == 0)

efectoTunelRampita :: Tiro -> Tiro
efectoTunelRampita tiro = UnTiro {velocidad = velocidad tiro * 2, precision = 100, altura = 0}

--------------------------------------------------------------------------------------------------------------------------------

laguna :: Int -> Obstaculo
laguna n = UnObstaculo (tiroSuperaLaguna n) (efectoLaguna n)

tiroSuperaLaguna :: Int -> Tiro -> Bool
tiroSuperaLaguna n tiro = (velocidad tiro > 80) && ((between 1 5) $ altura tiro)

efectoLaguna :: Int -> Tiro -> Tiro
efectoLaguna n tiro = UnTiro {velocidad = velocidad tiro, precision = precision tiro, altura = div (altura tiro) n }

--------------------------------------------------------------------------------------------------------------------------------

hoyo :: Obstaculo
hoyo = UnObstaculo tiroSuperaHoyo efectoHoyo

tiroSuperaHoyo :: Tiro -> Bool
tiroSuperaHoyo tiro = ((between 5 20) $ velocidad tiro) && (precision tiro > 95)

efectoHoyo :: Tiro -> Tiro
efectoHoyo = tiroDetenido

--------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 4 --

leSirveParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
leSirveParaSuperar jugador obstaculo palo = puedeSuperar obstaculo $ golpe jugador palo

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (leSirveParaSuperar jugador obstaculo) palos

obstaculosSuperadosTiro :: [Obstaculo] -> Tiro -> [Obstaculo]
obstaculosSuperadosTiro obstaculos tiro = filter (flip puedeSuperar tiro) obstaculos

cuantosObstaculosConsecutivos :: [Obstaculo] -> Tiro -> Int
cuantosObstaculosConsecutivos obstaculos tiro = length (obstaculosSuperadosTiro obstaculos tiro)

paloMasUtil :: [Obstaculo] -> Jugador -> Palo
paloMasUtil obstaculos jugador
  = maximoSegun (cuantosObstaculosConsecutivos obstaculos.golpe jugador) palos

--------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 5 --

{- 

jugadorDeTorneo = fst
puntosGanados   = snd

pierdenApuesta :: [(Jugador, Puntos)] -> [String]
pierdenApuesta puntosDeTorneo = (map (padre.jugadorDeTorneo) . filter (not . gano)) puntosDeTorneo

gano :: (Jugador, Puntos) -> (Jugador, Puntos) -> Bool
gano puntosDeTorneo puntosDeJugador 
  = (all ((< puntosGanados puntosDeJugador) . puntosGanados) . filter (/= puntosDeJugador)) puntosDeTorneo 

-}