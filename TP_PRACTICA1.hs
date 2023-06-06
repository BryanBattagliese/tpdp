-- TP "LAMBDA PROP" -- 

type Barrio     = String
type Mail       = String
type Requisito  = Depto -> Bool
type Busqueda   = [Requisito]

data Depto = Depto {
    ambientes :: Int,
    superficie :: Int,
    precio :: Int,
    barrio :: Barrio
} deriving (Show, Eq)

data Persona = Persona{
    mail :: Mail,
    busquedas :: [Busqueda]
}

ordenarSegun _ [] = []
ordenarSegun criterio (x:xs) =
    (ordenarSegun criterio . filter (not . criterio x)) xs ++ [x] ++
       (ordenarSegun criterio . filter (criterio x)) xs

between cotaInf cotaSup valor =
    valor <= cotaSup && valor >= cotaInf

deptosDeEjemplo = [Depto 3 70 95000  "Palermo",
                   Depto 2 45 50000  "Villa Urquiza",
                   Depto 4 99 120000 "Devoto",
                   Depto 1 35 40000  "El Palomar"]

----------------------------------------------------------------------
-- Punto 1 --

menor :: Ord a => (t -> a) -> t -> t -> Bool
menor funcion valor1 valor2 = funcion valor1 < funcion valor2

mayor :: Ord a => (t -> a) -> t -> t -> Bool
mayor funcion valor1 valor2 = funcion valor1 > funcion valor2

-- lista = ["hola" ,"fhsdf ", "gfsdgsdfgdsf", "fs"]
--1b prueba: ordenarSegun (mayor length) lista

----------------------------------------------------------------------
-- Punto 2 --

ubicadoEn :: [Barrio] -> Depto -> Bool
ubicadoEn barrios depto = elem (barrio depto) barrios

cumpleRango:: Ord a => (Depto -> a) -> a -> a -> Depto -> Bool
cumpleRango funcion valor1 valor2 depto = between valor1 valor2 (funcion depto)

----------------------------------------------------------------------
-- Punto 3 --

cumpleBusqueda :: Busqueda -> Depto -> Bool
cumpleBusqueda busqueda depto = all (\req -> req depto) busqueda

-- cumpleRequisito :: Depto -> Requisito -> Bool
-- cumpleRequisito depto requisito = requisito depto

buscar :: Busqueda -> (Depto -> Depto -> Bool) -> [Depto] -> [Depto]
buscar busqueda criterioOrd = ordenarSegun criterioOrd . filter (cumpleBusqueda busqueda) 


----------------------------------------------------------------------
-- Punto 4 --

leInteresa :: Depto -> Persona -> Bool
leInteresa depto = any (flip cumpleBusqueda depto) . busquedas

mailsDePersonasInteresadas :: Depto -> [Persona] -> [Mail]
mailsDePersonasInteresadas depto = map mail . filter (leInteresa depto)
