
% --- PUNTO 1 --- --- --- --- --- --- --- --- --- --- --- --- --- ---

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(dodain, Dia, HorarioInicio, HorarioFinal).
atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(juanC, Dia, HorarioInicio, HorarioFinal).

% Los otros dos puntos, no es necesario hacer nada gracias al concepto de universo cerrado. %

% --- PUNTO 2 --- --- --- --- --- --- --- --- --- --- --- --- --- ---

quienAtiende(Persona, Dia, Horario):-
    atiende(Persona, Dia, HorarioInicio, HorarioFinal),
    between(HorarioInicio, HorarioFinal, Horario).

% --- PUNTO 3 --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 
foreverAlone(Persona, Dia, Horario):-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(OtraPersona, Dia, Horario), Persona \= OtraPersona)).

% -*- PUNTO 4 -*- --- --- --- --- --- --- --- --- --- --- --- --- ---

posibilidadesAtencion(Dia, Personas):-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).
  
  combinar([], []).
  combinar([Persona|PersonasPosibles], [Persona|Personas]):-combinar(PersonasPosibles, Personas).
  combinar([_|PersonasPosibles], Personas):-combinar(PersonasPosibles, Personas).

% --- PUNTO 5 --- --- --- --- --- --- --- --- --- --- --- --- --- ---

% golosinas (Precio).
% cigarrillos (Marca).
% bebidaAlcoholica(Cantidad).
% bebidaSinAlcohol(Cantidad).

% ventas(Persona, Dia, [Ventas]).

ventas(dodain,  lunes10,     [golosinas(1200) , cigarrillos(jockey), golosinas(50)]).
ventas(dodain,  miercoles12, [bebidaAlcoholica(8) , bebidaSinAlcohol(1), golosinas(10)]).
ventas(martu,   miercoles12, [golosinas(1000) ,cigarrillos([chesterfield, colorado, parisiennes])]).
ventas(lucas,   martes11,    [golosinas(600)]).
ventas(lucas,   martes18,    [bebidaSinAlcohol(2) , cigarrillos(derby)]).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

diasQueVendio(Persona, Dias):-
    findall(Dia, ventas(Persona, Dia, _), ListaDias),
    list_to_set(ListaDias, Dias).

ventaImportante(golosinas(Precio)):-
    Precio > 100.
ventaImportante(bebidaAlcoholica(Cantidad)):-
    Cantidad > 1.
ventaImportante(bebidaSinAlcohol(Cantidad)):-
    Cantidad > 5.

ventaImportante(cigarrillos(Marca)):-
    length(Marca, Cantidad),
    Cantidad > 2.

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

tieneVentas(Persona):-
    ventas(Persona, _ , _).

primerVentaDelDiaEsImportante(Persona, Dia):-
    ventas(Persona, Dia, Ventas),
    nth1(1, Ventas, PrimerVenta),
    ventaImportante(PrimerVenta).
    
esSuertuda(Persona):-
    tieneVentas(Persona),
    forall(ventas(Persona, Dia, Ventas),
           primerVentaDelDiaEsImportante(Persona, Dia)).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

:- begin_tests(kiosko).

test(atienden_los_viernes, set(Persona = [vale, dodain, juanFdS])):-
  atiende(Persona, viernes, _, _).

test(personas_que_atienden_un_dia_puntual_y_hora_puntual, set(Persona = [vale, dodain, leoC])):-
  quienAtiende(Persona, lunes, 14).

test(dias_que_atiende_una_persona_en_un_horario_puntual, set(Dia = [lunes, miercoles, viernes])):-
  quienAtiende(vale, Dia, 10).

test(una_persona_esta_forever_alone_porque_atiende_sola, set(Persona=[lucas])):-
  foreverAlone(Persona, martes, 19).

test(persona_que_no_cumple_un_horario_no_puede_estar_forever_alone, fail):-
  foreverAlone(martu, miercoles, 22).

test(posibilidades_de_atencion_en_un_dia_muestra_todas_las_variantes_posibles, set(Personas=[[],[dodain],[dodain,leoC],[dodain,leoC,martu],[dodain,leoC,martu,vale],[dodain,leoC,vale],[dodain,martu],[dodain,martu,vale],[dodain,vale],[leoC],[leoC,martu],[leoC,martu,vale],[leoC,vale],[martu],[martu,vale],[vale]])):-
  posibilidadesAtencion(miercoles, Personas).

test(personas_suertudas, set(Persona = [martu, dodain])):-
    esSuertuda(Persona).

:- end_tests(kiosko).