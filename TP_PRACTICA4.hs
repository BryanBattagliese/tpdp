type Habilidad  = String
type Universo   = [Personaje]
type Gema       = Personaje -> Personaje 
type Planeta    = String

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
}

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: [Habilidad],
    planeta :: String
} deriving Show

---------------------------------------------------------------------------------------------------------------------------------
ironMan :: Personaje
ironMan = Personaje {nombre = "Iron Man", edad = 30, energia = 99, 
                     habilidades = ["Misiles", "Volar"], planeta = "Tierra"}

thor :: Personaje
thor = Personaje {nombre = "Thor", edad = 45, energia = 99, 
                     habilidades = ["Martillo", "Rayo"], planeta = "Tierra"}

drStrange :: Personaje
drStrange = Personaje {nombre = "DrStrange", edad = 56, energia = 99, 
                     habilidades = ["Golpeo"], planeta = "Tierra"}

capitanAmerica :: Personaje
capitanAmerica = Personaje {nombre = "CapitanAmerica", edad = 45, energia = 99, 
                     habilidades = ["Super escudo", "Super fuerza"], planeta = "Tierra"}

universo1  :: Universo 
universo1 = [ironMan, capitanAmerica, drStrange, thor]

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 1 --

guanteleteCompleto :: Guantelete -> Bool
guanteleteCompleto guantelete = ((== 6). length . gemas) guantelete && material guantelete == "uru"

reducirMitad :: Universo -> Universo
reducirMitad universo = take (div (length universo) 2) universo

chasquearElUniverso :: Universo -> Guantelete -> Universo
chasquearElUniverso universo guantelete
 | guanteleteCompleto guantelete = reducirMitad universo
 | otherwise = universo

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 2 --A--

universoAptoParaPendex :: Universo -> Bool
universoAptoParaPendex = any ((<=45) . edad)

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso = sum . map (energia) . filter (((>1) . length) . habilidades)

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 3 --

---------------------------------------------------------------------------------------------------------------------------------

quitarEnergia :: Int -> Personaje -> Personaje
quitarEnergia valor personaje = personaje {energia = energia personaje - valor}

quitarTodaEnergia :: Personaje -> Personaje
quitarTodaEnergia personaje = quitarEnergia (energia personaje) personaje

quitarHabilidad :: Personaje -> Habilidad -> Personaje
quitarHabilidad personaje habilidad = personaje {habilidades = (filter (/=habilidad) . habilidades) personaje}

quitarTodasHabilidades :: Personaje -> Personaje
quitarTodasHabilidades personaje = personaje {habilidades = []}

tiene2oMasHabilidades :: Personaje -> Bool
tiene2oMasHabilidades personaje = (<=2) (length $ habilidades personaje)

---------------------------------------------------------------------------------------------------------------------------------
mente :: Int -> Gema
mente = quitarEnergia

alma :: Habilidad -> Gema
alma habilidad = quitarEnergia 10 . flip quitarHabilidad habilidad

espacio :: Planeta -> Gema
espacio planeta personaje = quitarEnergia 20 personaje {planeta = planeta}

poder :: Gema
poder personaje  
 | tiene2oMasHabilidades personaje = quitarTodaEnergia . quitarTodasHabilidades $ personaje
 | otherwise = quitarTodaEnergia personaje

tiempo :: Gema
tiempo personaje = quitarEnergia 50 personaje {edad = (max 18 . div (edad personaje)) 2 } 

gemaLoca :: Gema -> Gema
gemaLoca gema = gema.gema

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 4 --

guanteleteDePrueba :: Guantelete
guanteleteDePrueba = Guantelete {
    material = "goma", 
    gemas = [tiempo, alma ("usar Mjolnir"), gemaLoca (poder.alma("programación en Haskell"))]
    }

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 5 --

gemaEnPersonaje :: Personaje -> Gema -> Personaje
gemaEnPersonaje personaje gema = gema $ personaje

utilizar :: [Gema] -> Gema
utilizar gemas personaje = foldl (gemaEnPersonaje) personaje gemas

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 6 -- NO LO PUDE SACAR -- 

gemaMasPoderosa :: Personaje -> Guantelete -> Gema
gemaMasPoderosa personaje guantelete = gemaMasPoderosaDe personaje $ gemas guantelete

gemaMasPoderosaDe :: Personaje -> [Gema] -> Gema
gemaMasPoderosaDe _ [gema] = gema
gemaMasPoderosaDe personaje (gema1:gema2:gemas) 
 | (energia.gema1) personaje < (energia.gema2) personaje = gemaMasPoderosaDe personaje (gema1:gemas)
 | otherwise = gemaMasPoderosaDe personaje (gema2:gemas)

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 7 --

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos  = Guantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3 . gemas) guantelete

-- a - no se puede evaluar la gema mas poderosa, ya que la lista de gemas es infinita

-- b - si se puede ejecutar ya que a pesar de que el guantelete cuenta con infinitas gemas,
--     solo se piden las primeras 3 con la funcion "usoLasTresPrimerasGemas".