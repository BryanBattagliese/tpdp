% --- --- --- --- --- --- --- --- --- --- 

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% --- PUNTO 1 --- --- --- --- --- --- --- 

persona(egon).
persona(peter).
persona(winston).
persona(ray).

% tiene(Persona, Herramienta).

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% --- PUNTO 2 --- --- --- --- --- --- --- 

% satisfaceNecesidad(Persona, Herramienta).

satisfaceNecesidad(Persona, Herramienta):-
    tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(Potencia)):-
    tiene(Persona, aspiradora(PotenciaX)),
    between(0, PotenciaX, Potencia).
    
satisfaceNecesidadLista(Persona, Lista):-
	member(Herramienta, Lista),
	satisfaceNecesidad(Persona, Herramienta).

% -*- PUNTO 3 -*- -*- -*- -*- -*- -*- -*- -*-

puedeRealizar(Persona, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Persona, varitaDeNeutrones).

% satisface la necesidad de todas las herramientas requeridas
puedeRealizar(Persona, Tarea):-
	tiene(Persona, _),
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	forall(member(Herramienta, ListaDeHerramientas),
		   satisfaceNecesidad(Persona, Herramienta)).

% --- PUNTO 4 --- --- --- --- --- --- --- 

precio(Tarea, PrecioFinal):-
    tareaPedida(Cliente, Tarea, Metros2),
    

