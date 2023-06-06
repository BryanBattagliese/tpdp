data Elemento = Elemento { 
    tipo    :: String,
    ataque  ::  (Personaje -> Personaje),
    defensa ::  (Personaje -> Personaje) }

data Personaje = Personaje { 
    nombre       :: String,
    salud        :: Int,
    elementos    :: [Elemento],
    anioPresente :: Int }

---------------------------------------------------------------------------------------------------------------------------------

elem1 = Elemento {tipo = "Agua", ataque = causarDanio 50, defensa = mandarAlAnio 100}
elem2 = Elemento {tipo = "Tierra", ataque = causarDanio 20, defensa = mandarAlAnio 600}
elem3 = Elemento {tipo = "Fuego", ataque = causarDanio 70, defensa = mandarAlAnio 1000}

pers1 = Personaje {nombre = "Jack", salud = 100, elementos = [elem1], anioPresente = 2010}
pers2 = Personaje {nombre = "Jose", salud = 50, elementos = [elem2, elem3], anioPresente = 1900}
pers3 = Personaje {nombre = "Juan", salud = 70, elementos = [elem1, elem2, elem3], anioPresente = 1000}

---------------------------------------------------------------------------------------------------------------------------------

cambiarSalud :: Int -> Personaje -> Personaje
cambiarSalud valor personaje = personaje {salud = salud personaje + valor}

esDeTipo :: String -> Elemento -> Bool
esDeTipo esTipo elemento = esTipo == tipo elemento

aplicarAtaqueElemento :: Personaje -> Elemento -> Personaje
aplicarAtaqueElemento personaje elemento = ataque elemento personaje

aplicarDefensaElemento :: Personaje -> Elemento -> Personaje
aplicarDefensaElemento personaje elemento = defensa elemento personaje

diferenciaSalud :: Personaje -> Personaje -> Int
diferenciaSalud per1 per2 = salud per2 - salud per1

esEnemigoMortal :: Personaje -> Personaje -> Bool
esEnemigoMortal personaje enemigo = (any (tieneAtaqueMortal personaje) . elementos) enemigo

tieneAtaqueMortal :: Personaje -> Elemento -> Bool
tieneAtaqueMortal personaje elemento = danioQueProduce personaje elemento == salud personaje

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 1 --

mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anio (Personaje nombre salud elementos _) = Personaje nombre salud elementos anio

meditar :: Personaje -> Personaje
meditar personaje = cambiarSalud (div (salud personaje) 2) personaje

causarDanio :: Int -> Personaje -> Personaje
causarDanio danioIndicado personaje = cambiarSalud (max 0 (-danioIndicado)) personaje

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 2 --

esMalvado :: Personaje -> Bool
esMalvado personaje = (any (esDeTipo "Maldad") . elementos)  personaje

danioQueProduce :: Personaje -> Elemento -> Int
danioQueProduce personaje elemento = diferenciaSalud personaje (aplicarAtaqueElemento personaje elemento)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje enemigos = filter (esEnemigoMortal personaje) enemigos

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 3 --

noHacerNada = id

concentracion :: Int -> Elemento 
concentracion nivelIndicado = Elemento {
    tipo = "Magia", 
    ataque = noHacerNada, 
    defensa = (!! nivelIndicado) . iterate meditar
    }

esbirro :: Elemento
esbirro = Elemento {
    tipo = "Maldad", 
    ataque = causarDanio 1, 
    defensa = noHacerNada
}

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad esbirro

katanaMagica :: Elemento
katanaMagica = Elemento{
    tipo = "Magia",
    ataque = causarDanio 1000,
    defensa = noHacerNada
}

jack :: Personaje
jack = Personaje {
    nombre = "Jack",
    salud = 300,
    elementos = [(concentracion 3), katanaMagica],
    anioPresente = 200
}

portalAlFuturoDesde :: Int -> Elemento
portalAlFuturoDesde anio = Elemento {
    tipo    = "Magia",
    ataque  = (mandarAlAnio (anio + 2800)),
    defensa = (aku anio . salud)
}

aku :: Int -> Int -> Personaje
aku anio salud = Personaje{
    nombre = "Aku",
    salud = salud,
    elementos = [(concentracion 4), portalAlFuturoDesde anio] ++ esbirrosMalvados (100*anio),
    anioPresente = anio
}

---------------------------------------------------------------------------------------------------------------------------------
-- PUNTO 4 --

luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor 
 | salud atacante == 0 = (defensor, atacante)
 | otherwise = luchar proximoAtacante proximoDefensor
    where proximoAtacante = usarElementos ataque defensor (elementos atacante)
          proximoDefensor = usarElementos defensa atacante (elementos atacante)

usarElementos :: (Elemento -> Personaje -> Personaje) -> Personaje -> [Elemento] -> Personaje
usarElementos funcion personaje elementos = foldl afectar personaje (map funcion elementos)

afectar personaje funcion = funcion personaje

f x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))

f :: (Eq t1, Num t2) => (t1 -> a1 -> (a2, a2)) -> (t2 -> t1) -> t1 -> [a1] -> [a2]

