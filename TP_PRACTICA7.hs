type Condicion = Viaje -> Bool

data Chofer = Chofer {
    nombreChofer :: String,
    kmAuto :: Int,
    viajes :: [Viaje],
    condicion :: Condicion
} 

data Viaje = Viaje {
    fecha :: (Int,Int,Int),
    cliente :: Cliente,
    costo :: Int
} deriving (Show, Eq)

data Cliente = Cliente {
    nombreCliente  :: String,
    direccion :: String
} deriving (Show, Eq)

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- PUNTO 2 --

sinCondicion :: Condicion
sinCondicion _ = True

mayorA200 :: Condicion
mayorA200 = (> 200) . costo

segunNombre :: Int -> Condicion                                         -- maso
segunNombre num = (>num) . length . nombreCliente . cliente

segunZona :: String -> Condicion
segunZona zona = (/=) zona . direccion . cliente

----------------------------------------------------------------------------------------------------
-- PUNTO 3 --

lucas    = Cliente {nombreCliente = "Lucas", direccion = "Victoria"}

daniel   = Chofer  {nombreChofer = "Daniel", 
                    kmAuto = 23500, 
                    viajes = [Viaje {fecha = (20,04,2017), cliente = lucas, costo = 150}], 
                    condicion = not . segunZona "Olivos"}

alejandra = Chofer {nombreChofer = "Alejandra", 
                    kmAuto = 180000, 
                    viajes = [], 
                    condicion = sinCondicion}

----------------------------------------------------------------------------------------------------
-- PUNTO 4 -- NO -- 

puedeTomar :: Viaje -> Chofer -> Bool
puedeTomar viaje chofer = condicion chofer $ viaje

----------------------------------------------------------------------------------------------------
-- PUNTO 5 --

liquidacionChofer :: Chofer -> Int
liquidacionChofer = sum . map costo . viajes

----------------------------------------------------------------------------------------------------
-- PUNTO 6 --

ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) = 
    (ordenarSegun criterio . filter (not . criterio x)) xs ++ [x] ++ (ordenarSegun criterio . filter (criterio x)) xs

puedenRealizarViaje :: Viaje -> [Chofer] -> [Chofer]
puedenRealizarViaje viaje choferes = filter (puedeTomar viaje) choferes

choferConMenosViajes :: [Chofer] -> Chofer
choferConMenosViajes choferes = head (ordenarSegun (\x y -> length (viajes x) < length (viajes y)) choferes)

efectuarElViaje :: Chofer -> Viaje -> Chofer
efectuarElViaje chofer viaje = chofer {viajes = viajes chofer ++ [viaje]}

realizarUnViaje :: Viaje -> [Chofer] -> Chofer
realizarUnViaje viaje = flip efectuarElViaje viaje . choferConMenosViajes . puedenRealizarViaje viaje

----------------------------------------------------------------------------------------------------
-- PUNTO 7 --

nitoInfy   = Chofer  {nombreChofer = "Nito Infy", 
                      kmAuto = 70000, 
                      viajes = [infinitosViajes], 
                      condicion = segunNombre 3}


infinitosViajes = Viaje {fecha = (11,03,2017), cliente = lucas, costo = 50}

repetirViaje infinitosViajes = infinitosViajes : repetirViaje infinitosViajes

-- b - no se puede calcular la liquidacion ya que depende exclusivamente de la sumatoria de costos de los viajes realizados
-- c - si puede tomar un viaje de lucas por 500 el 2,5,2017, ya que teniendo en cuenta los conceptos de evaluacion diferida,
--     en este caso no afecta el tomar o no un nuevo viaje.

----------------------------------------------------------------------------------------------------
-- PUNTO 8 --

gongNeng :: Ord c => c -> (c -> Bool) -> (a -> c) -> [a] -> c
gongNeng arg1 arg2 arg3 = 
     max arg1 . head . filter arg2 . map arg3
