% -------------------------------------------------------------------------------- %

% tripulante(Pirata , Tripulacion).
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% -------------------------------------------------------------------------------- %

% impactoEnRecompensa (Pirata, Evento , Monto).
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).                % sombreroDePaja
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000). 
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).    % heart
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).        % piratasDeArlong
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

% -------------------------------------------------------------------------------- %
% --- PUNTO 1 ---

participoDeEvento(Tripulacion, Evento):-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata, Evento, Monto).

ambasParticiparon(Tripulacion1, Tripulacion2, Evento):-
    participoDeEvento(Tripulacion1, Evento),
    participoDeEvento(Tripulacion2, Evento),
     Tripulacion1 \= Tripulacion2.

% -------------------------------------------------------------------------------- %
% --- PUNTO 2 ---

pirataDestacado(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    not((tripulante(Pirata2, _),
    Pirata \= Pirata2,
    impactoEnRecompensa(Pirata2, Evento, Recompensa2),
    Recompensa < Recompensa2)).

% -------------------------------------------------------------------------------- %
% --- PUNTO 2 --- OTRA ALTERNATIVA ---

pirataDestacado(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    forall(impactoEnRecompensa(_, Evento, Recompensa2),
    Recompensa > Recompensa2).

% -------------------------------------------------------------------------------- %
% --- PUNTO 3 ---

pasoDesapercibido(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    participoDeEvento(Tripulacion, Evento),
    not((impactoEnRecompensa(Pirata, Evento, _))).

% -------------------------------------------------------------------------------- %
% --- PUNTO 4 ---  UNICO DETALLE: EL "tripulante", colocarlo dentro del findall ---

recompensaTotalTripulacion(Tripulacion, Recompensa):-
    findall(Monto, 
        (tripulante(Pirata, Tripulacion), impactoEnRecompensa(Pirata,_,Monto)), 
        Recompensas),
    sum_list(Recompensas, Recompensa).

recompensaTotalPirata(Pirata, Recompensa):-
    findall(Monto, 
        (tripulante(Pirata, Tripulacion), impactoEnRecompensa(Pirata,_,Monto)), 
        Recompensas),
    sum_list(Recompensas, Recompensa).

% -------------------------------------------------------------------------------- %
% --- PUNTO 5 ---

esPeligroso(Pirata):-
    tripulante(Pirata, _),
    recompensaTotalPirata(Pirata, Recompensa),
    Recompensa > 100000000.
esPeligroso(Pirata):-
    comio(Pirata,Fruta),
    frutaPeligrosa(Fruta).

esTemible(Tripulacion):-
    forall(tripulante(Pirata, Tripulacion),
           esPeligroso(Pirata)).
esTemible(Tripulacion):-
    recompensaTotalTripulacion(Tripulacion,Recompensa),
    Recompensa > 500000000.

% -------------------------------------------------------------------------------- %
% --- PUNTO 6a ---

% comio(Pirata, Fruta).
comio(luffy  , paramecia(gomugomu)).
comio(law    , paramecia(opeope)).
comio(buggy  , paramecia(barabara)).
comio(chopper, zoan(hitohito, humano)).
comio(lucci  , zoan(nekoneko, leopardo)).
comio(smoker , logia(mokumoku, humo)).

%frutaPeligrosa(Fruta).
frutaPeligrosa(paramecia(opeope)).
frutaPeligrosa(zoan(_, Especie)):-
    esFeroz(Especie).
frutaPeligrosa(logia(_,_)).

%esFeroz(Especie).
esFeroz(lobo).
esFeroz(leopardo).
esFeroz(anaconda).

% -------------------------------------------------------------------------------- %
% --- PUNTO 7 ---

noPuedeNadar(Pirata):-
    comio(Pirata, Fruta).

tripulacionEsDeAsfalto(Tripulacion):-
    forall(tripulante(Pirata, Tripulacion),
           noPuedeNadar(Pirata)).