% --- PARTE 1 --- %

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

mago(harry).
mago(hermione).
mago(draco).
mago(ron).
mago(luna).
mago(bryan).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).
sangre(neville, pura).

tieneCaracteristica(harry, coraje).
tieneCaracteristica(harry, amistoso).
tieneCaracteristica(harry, orgullo).
tieneCaracteristica(harry, inteligencia).

tieneCaracteristica(draco, inteligencia).
tieneCaracteristica(draco, orgullo).

tieneCaracteristica(hermione, inteligencia).
tieneCaracteristica(hermione, orgullo).
tieneCaracteristica(hermione, responsabilidad).

tieneCaracteristica(neville, responsabilidad).
tieneCaracteristica(neville, coraje).
tieneCaracteristica(neville, amistoso).

odia(harry,slytherin).
odia(draco,hufflepuff).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

caracteristicaBuscada(slytherin, coraje).
caracteristicaBuscada(slytherin, orgullo).
caracteristicaBuscada(slytherin, inteligencia).

caracteristicaBuscada(gryffindor, coraje).

caracteristicaBuscada(ravenclaw, inteligencia).
caracteristicaBuscada(ravenclaw, responsabilidad).

caracteristicaBuscada(hufflepuff, amistoso).


% --- PUNTO 1 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

% permiteEntrar(Casa, Mago).
permiteEntrar(Casa, _):-
    casa(Casa),
    Casa \= slytherin.
permiteEntrar(slytherin,Mago):-
    sangre(Mago, TipoDeSangre),
    TipoDeSangre \= impura.

% --- PUNTO 2 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

tieneCaracterApropiado(Mago, Casa):-
    casa(Casa), mago(Mago),
    forall(((casa(Casa), caracteristicaBuscada(Casa, Caracteristica))),
            tieneCaracteristica(Mago, Caracteristica)).

% --- PUNTO 3 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

posibleCasa(Mago, Casa):-
    tieneCaracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not((odia(Mago, Casa))).
posibleCasa(hermione, gryffindor).

% --- PUNTO 4 --- --- Tambien se puede hacer con el NH1 --- --- --- --- ---

esAmistoso(Mago):-
    tieneCaracteristica(Mago, amistoso).

todosAmistosos(Magos):-
    forall(member(Mago, Magos), 
           esAmistoso(Mago)).

cadenaDeCasas([Mago1, Mago2 | OtrosMagos]):-
    posibleCasa(Mago1, Casa) == posibleCasa(Mago2, Casa),
    cadenaDeCasas([Mago2 | OtrosMagos]).
cadenaDeCasas([_]).

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).


% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

% accion(Mago, Accion, Puntos).
accion(harry, andarDeNoche, -50).
accion(harry, ganarleAVoldemort, 60).
accion(harry, bosque, -50).
accion(harry, tercerPiso, -75).
accion(hermione, tercerPiso, -75).
accion(hermione, seccionRestringidaBiblio, -10).
accion(hermione, salvarAmigos, 50).
accion(draco, mazmorras, 0).
accion(ron, ganarPartidaAjedrez, 50).

accion(bryan, ganarPartidaAjedrez, 50).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).
esDe(bryan,ravenclaw).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

malaAccion(Accion):-
    accion(_, Accion, Puntos),
    Puntos < 0.

% --- PUNTO 1 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

esBuenAlumno(Mago):-
    mago(Mago), 
    accion(Mago,_,_),
    forall(accion(Mago, Accion, _),
           not((malaAccion(Accion)))).

esRecurrente(Accion):-
    accion(Mago, Accion,_),
    accion(Mago2, Accion,_),
    Mago \= Mago2.

% --- PUNTO 2 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

puntajeTotalCasa(Casa, PuntajeTotal):-
    esDe(_, Casa),
    findall(PuntajeTotalMago, 
           (esDe(Mago, Casa), puntajeTotalMago(Mago, PuntajeTotalMago)),
            ListaPuntaje),
    sum_list(ListaPuntaje, PuntajeTotal).

% --- PUNTO 3 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

casaGanadora(Casa):-
    puntajeTotalCasa(Casa, PuntajeMayor),
    forall((puntajeTotalCasa(OtraCasa, PuntajeMenor), Casa \= OtraCasa),
           PuntajeMayor > PuntajeMenor).

% --- PUNTO 4 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

profesor(snape).
profesor(flitwick).

% respondioPreguntaEnClase(Mago, Pregunta, Dificultad, Profesor).
respondioPreguntaEnClase(hermione, "donde se encuentra un Bezoar", 20, snape).
respondioPreguntaEnClase(hermione, "como hacer levitar una pluma", 25, flitwick).

puntosPorPreguntaEnClase(Mago, PuntosObtenidos):-
    respondioPreguntaEnClase(Mago, _ , Dificultad, Profesor),
    Profesor == snape,
    PuntosObtenidos is Dificultad / 2.
puntosPorPreguntaEnClase(Mago, PuntosObtenidos):-
    respondioPreguntaEnClase(Mago, _ , Dificultad, Profesor),
    Profesor \= snape,
    PuntosObtenidos = Dificultad.

puntajeTotalMago(Mago, PuntajeTotal):-
    mago(Mago),
    findall(Puntos, accion(Mago, _ , Puntos), Puntaje),
    findall(PuntosObtenidos, puntosPorPreguntaEnClase(Mago, PuntosObtenidos), PuntosExtra),
    union(Puntaje, PuntosExtra, ListaDePuntosFinal),
    sum_list(ListaDePuntosFinal, PuntajeTotal).
    