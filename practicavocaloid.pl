%canta(nombreCancion, cancion)%
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

novedoso(Cantante) :- 
sabeAlMenosDosCanciones(Cantante),
tiempoTotalCanciones(Cantante, Tiempo),
Tiempo < 15.

sabeAlMenosDosCanciones(Cantante) :-
	canta(Cantante, UnaCancion),
	canta(Cantante, OtraCancion),
	UnaCancion \= OtraCancion.

tiempoTotalCanciones(Cantante, TiempoTotal) :-
	findall(TiempoCancion,tiempoDeCancion(Cantante, TiempoCancion), Tiempos), 
    sumlist(Tiempos,TiempoTotal).

tiempoDeCancion(Cantante,TiempoCancion):-  
      canta(Cantante,Cancion),
      tiempo(Cancion,TiempoCancion).

tiempo(cancion(_, Tiempo), Tiempo).


acelerado(Cantante) :- 
vocaloid(Cantante), 
not((tiempoDeCancion(Cantante,Tiempo),Tiempo > 4)).

vocaloid(Cantante):-
canta(Cantante, _).


%concierto(nombre, pais, fama, tipoConcierto)%
concierto(mikuExpo, eeuu, 2000, gigante(2,6)).
concierto(magicalMirai, japon, 3000, gigante(3,10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, diminuto(4)).


puedeParticipar(hatsuneMiku,Concierto):-
	concierto(Concierto, _, _, _).

puedeParticipar(Cantante, Concierto):-
	vocaloid(Cantante),
	Cantante \= hatsuneMiku,
	concierto(Concierto, _, _, Requisitos),
	cumpleRequisitos(Cantante, Requisitos).

cumpleRequisitos(Cantante, gigante(CantCanciones, TiempoMinimo)):-
	cantidadCanciones(Cantante, Cantidad),
	Cantidad >= CantCanciones,
	tiempoTotalCanciones(Cantante, Total),
	Total > TiempoMinimo.

cumpleRequisitos(Cantante, mediano(TiempoMaximo)):-
	tiempoTotalCanciones(Cantante, Total),
	Total < TiempoMaximo.

cumpleRequisitos(Cantante, diminuto(TiempoMinimo)):-
	canta(Cantante, Cancion),
	tiempo(Cancion, Tiempo),
	Tiempo > TiempoMinimo.

cantidadCanciones(Cantante, Cantidad) :- 
    findall(Cancion, canta(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

masFamoso(Cantante) :-
	nivelFamoso(Cantante, NivelMasFamoso),
	forall(nivelFamoso(_, Nivel), NivelMasFamoso >= Nivel).

nivelFamoso(Cantante, Nivel):- 
    famaTotal(Cantante, FamaTotal), cantidadCanciones(Cantante, Cantidad), 
    Nivel is FamaTotal * Cantidad.

famaTotal(Cantante, FamaTotal):- 
    vocaloid(Cantante),
    findall(Fama, famaConcierto(Cantante, Fama), CantidadesFama), 	
    sumlist(CantidadesFama, FamaTotal).

famaConcierto(Cantante, Fama):-
    puedeParticipar(Cantante,Concierto),
    fama(Concierto, Fama).

fama(Concierto,Fama):- 
    concierto(Concierto,_,Fama,_).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

conoce(megurineLuka,hatsuneMiku).
conoce(megurineLuka,gumi).
conoce(gumi,seeU).
conoce(seeU,kaito).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

conocido(Cantante, Conocido):-
    conoce(Cantante, Conocido).
conocido(Cantante, Conocido):-
    conoce(Cantante, OtroCantente),
    conoce(OtroCantente, Conocido).

unicoParticipante(Cantante, Concierto):-
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, OtroCantante),
         puedeParticipar(OtroCantante, Concierto))).

% hatsune en todos
% luka en mikuExpo y mikuFest
% seeU en mikuExpo y mikuFest
% gumi en mikuExpo y mikuFest