type Idioma = String
type Excursion = Turista -> Turista
type Elemento = String
type Minutos = Int
type Marea = String
type Tour  = [Excursion]

data Turista = Turista{
    nivelDeCansansio :: Int,
    nivelDeStress    :: Int,
    estaViajandoSolo :: Bool,
    idiomasQueHabla  :: [Idioma]
} deriving Show

---------------------------------------------------------------------------------------------------------------------------
cambiarCansancio :: Int -> Turista -> Turista
cambiarCansancio cant turista = turista {nivelDeCansansio = nivelDeCansansio turista + cant}

cambiarStress :: Int -> Turista -> Turista
cambiarStress cant turista = turista {nivelDeStress = nivelDeStress turista + cant}

cambiarStressPorcentual :: Int -> Turista -> Turista
cambiarStressPorcentual cant turista = cambiarStress (div (cant * nivelDeStress turista) 100) turista

aprenderIdioma :: Idioma -> Turista -> Turista
aprenderIdioma idioma turista = turista {idiomasQueHabla = idioma : idiomasQueHabla turista}

turistaAcompaniado :: Turista -> Turista
turistaAcompaniado turista = turista {estaViajandoSolo = False}

---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
-- PUNTO 1 --

ana   = Turista 00 21 False ["Espanol"]
beto  = Turista 15 15 True  ["Aleman"]
cathi = Turista 15 15 True  ["Aleman", "Catalan"]

---------------------------------------------------------------------------------------------------------------------------
-- PUNTO 2 --

irALaPlaya :: Excursion
irALaPlaya turista
 | estaViajandoSolo turista = cambiarCansancio (-5) turista
 | otherwise = cambiarStress (-1) turista

apreciarAlgunElementoDelPaisaje :: Elemento -> Excursion
apreciarAlgunElementoDelPaisaje elemento = cambiarStress (length elemento) 

salirAHablarUnIdiomaEspecifico :: Idioma -> Excursion
salirAHablarUnIdiomaEspecifico idiomaNuevo =  turistaAcompaniado . aprenderIdioma idiomaNuevo

intensidad :: Minutos -> Int
intensidad minutos = div minutos 4

caminar :: Minutos -> Excursion
caminar minutos = cambiarStress (-intensidad minutos) . cambiarCansancio (intensidad minutos)

paseoEnBarco :: Marea -> Turista -> Turista
paseoEnBarco "fuerte"     = (\turista -> turista { nivelDeStress = nivelDeStress turista + 6, nivelDeCansansio = nivelDeCansansio turista + 10 })
paseoEnBarco "tranquila"  = salirAHablarUnIdiomaEspecifico "aleman" . apreciarAlgunElementoDelPaisaje "mar" . caminar 10
paseoEnBarco "moderada"   = id

---------------------------------------------------------------------------------------------------------------------------

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion = excursion . cambiarStressPorcentual (-10)

---------------------------------------------------------------------------------------------------------------------------
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Int) -> Turista -> Excursion -> Int
deltaExcursionSegun indice turista excursion = 
    deltaSegun indice (hacerExcursion excursion turista) turista

excursionEducativa :: Turista -> Excursion -> Bool
excursionEducativa turista =  (>0) . deltaExcursionSegun (length . idiomasQueHabla) turista

excursionesDesestresantes :: Turista  -> [Excursion] -> [Excursion] 
excursionesDesestresantes  turista = filter (esDesestresante turista) 

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista = (<(-2)) . deltaExcursionSegun (nivelDeStress) turista

---------------------------------------------------------------------------------------------------------------------------
-- PUNTO 3 -a-

tourCompleto :: Tour
tourCompleto =  [caminar 20, apreciarAlgunElementoDelPaisaje "cascada", caminar 40, irALaPlaya, (salirAHablarUnIdiomaEspecifico "melmacquiano")]

ladoB :: Excursion -> Tour
ladoB excursionElegida = [paseoEnBarco "tranquila", excursionElegida, caminar 120]

excursionEnOtraIsla :: Marea -> Excursion
excursionEnOtraIsla "fuerte"  =  apreciarAlgunElementoDelPaisaje "lago"
excursionEnOtraIsla marea     =  irALaPlaya

islaVecina :: Marea -> Tour
islaVecina marea = [paseoEnBarco marea, excursionEnOtraIsla marea , paseoEnBarco marea]

---------------------------------------------------------------------------------------------------------------------------
-- PUNTO 3 -b-

hacerTour :: Turista -> Tour -> Turista
hacerTour turista tour = foldl (flip hacerExcursion) (cambiarStress (length tour) turista) tour

esConvincente :: Turista -> Tour -> Bool
esConvincente turista = any (dejaAcompañado turista) . excursionesDesestresantes turista

dejaAcompañado :: Turista -> Excursion -> Bool
dejaAcompañado turista = not . estaViajandoSolo . flip hacerExcursion turista

tourConvincente :: Turista -> [Tour] -> Bool
tourConvincente turista = any (esConvincente turista)

espiritualidad :: Tour -> Turista -> Int
espiritualidad tour turista = deltaSegun (\tur -> nivelDeCansansio tur + nivelDeStress tur)(hacerTour turista tour) turista

efectividadTour :: Tour -> [Turista] -> Int  
efectividadTour tour = sum . map (espiritualidad tour) . filter (flip esConvincente tour)

---------------------------------------------------------------------------------------------------------------------------
-- PUNTO 4a --

tourInfinitasPlayas :: Turista -> Tour
tourInfinitasPlayas turista = [irALaPlaya] ++ tourInfinitasPlayas turista

--4b -> para ana si. para beto no.
--4c -> no, ya que al ser infinito nunca podremos conocer la espiritualidad.