type Recurso    = String
type Estrategia = Pais -> Pais
type Receta     = [Estrategia]
--------------------------------------------------------------------------------------------------
-- PUNTO 1 --

data Pais = Pais {
    ingresoPerCapita       :: Float,
    poblacionActivaPublico :: Float,
    poblacionActivaPrivado :: Float,
    recursosNaturales      :: [Recurso],
    deudaConFMI            :: Float
} deriving (Eq, Show)

namibia     = Pais 4140 400000 650000 ["petroleo","ecoturismo"] 50
argentina   = Pais 4140 400000 650000 recursosNaturalesInfinitos 245

--------------------------------------------------------------------------------------------------
-- PUNTO 2 --

prestarMillones :: Float -> Estrategia
prestarMillones millones pais = pais {deudaConFMI =  deudaConFMI pais + (millones + millones * 0.5)}

reducirPuestosSectorPublico :: Float -> Estrategia
reducirPuestosSectorPublico cantidadPuestos pais
 | cantidadPuestos > 100 = pais {ingresoPerCapita = ingresoPerCapita pais - (ingresoPerCapita pais * 0.20), 
                                 poblacionActivaPublico = poblacionActivaPublico pais - cantidadPuestos}
 | otherwise             = pais {ingresoPerCapita = ingresoPerCapita pais - (ingresoPerCapita pais * 0.15), 
                                 poblacionActivaPublico = poblacionActivaPublico pais - cantidadPuestos}

{- reducirPuestosSectorPublico :: Int -> Pais -> Pais
reducirPuestosSectorPublico cantidadPuestos (Pais ingresoPerCapita poblacionActivaPublico poblacionActivaPrivado recursosNaturales deudaConFMI)
 | poblacionActivaPublico > 100 = 
    (Pais (ingresoPerCapita - (div (ingresoPerCapita * 20) 100)) (poblacionActivaPublico - cantidadPuestos) poblacionActivaPrivado recursosNaturales deudaConFMI)
 | otherwise =
     (Pais (ingresoPerCapita - (div (ingresoPerCapita * 15) 100)) (poblacionActivaPublico - cantidadPuestos) poblacionActivaPrivado recursosNaturales deudaConFMI) -}

quitarRecurso :: Recurso -> [Recurso] -> [Recurso]
quitarRecurso recurso = filter (/= recurso)

explotacionRecursoNatural :: Recurso -> Estrategia
explotacionRecursoNatural recurso pais = pais {recursosNaturales = quitarRecurso recurso $ recursosNaturales pais , 
                                               deudaConFMI = deudaConFMI pais - 2000000}

pbi :: Pais -> Float
pbi pais = (ingresoPerCapita pais * (poblacionActivaPrivado pais + poblacionActivaPublico pais))

blindaje :: Estrategia
blindaje pais = (prestarMillones (pbi pais * 0.5) . reducirPuestosSectorPublico 500) pais

--------------------------------------------------------------------------------------------------
-- PUNTO 3 --

receta1 :: Estrategia
receta1 = prestarMillones 200000000 . explotacionRecursoNatural "mineria"

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

--------------------------------------------------------------------------------------------------
-- PUNTO 4 -- A no -- B si --

puedenZafar :: [Pais] -> [Pais]
puedenZafar = filter $ elem ("petroleo") . recursosNaturales

totalDeuda :: [Pais] -> Float
totalDeuda = sum . map (deudaConFMI)

-- orden superior : en la utilizacion de filter, elem, map y sum.
-- composicion    : en ambas funciones donde hay "." o "$".
-- aplicacion par : en ambas, ej el map esta aplicado parcialmente.

--------------------------------------------------------------------------------------------------
-- PUNTO 5 -- NO LO PUDE HACER -- 

estaOrdenado :: Pais -> [Receta] -> Bool
estaOrdenado pais [receta] = True
estaOrdenado pais (receta1:receta2:recetas)
     = revisarPBI receta1 pais <= revisarPBI receta2 pais && estaOrdenado pais (receta2:recetas)
     where revisarPBI receta = pbi . aplicarReceta receta

--------------------------------------------------------------------------------------------------
-- PUNTO 6 --

recursosNaturalesInfinitos :: [Recurso]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

{- 
- evaluar puedenZafar con recursosNaturalesInfinitos
La funcion se evaluara de manera infinita, buscando el recurso "petroleo"


- evaluar totalDeuda con recursosNaturalesInfinitos
Mientras que en este caso, teniendo en cuenta el concepto de evaluacion diferida
la funcion nos dara un resultado ya que la misma no depende del apartado de recursosNaturales.

-} 

-- TOTAL: de 6 puntos pude hacer 4 (1/2) -- :'D