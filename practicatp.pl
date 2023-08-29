% BASE DE CONOCIMIENTOS %

% objetivo(Proyecto, Objetivo, TareaARealizar)
objetivo(higiene, almejas, recolectarMaterial(playa)).
objetivo(higiene, algas, recolectarMaterial(mar)).
objetivo(higiene, grasa, recolectarMaterial(animales)).
objetivo(higiene, hidroxidoDeCalcio, quimica([hacerPolvo, diluirEnAgua])).
objetivo(higiene, hidroxidoDeSodio, quimica([mezclarIngredientes])).
objetivo(higiene, jabon, quimica([mezclarIngredientes, dejarSecar])).

%% Agregar objetivos para otros proyectos aquí...

objetivo(salud, plantaAlgodon, recolectarMaterial(bosque)).
objetivo(salud, vendaje, quimica([hilado, tejido, esterilizado])).
objetivo(salud, metal, recolectarMaterial(mina)).
objetivo(salud, tijera, artesania(4)).
objetivo(salud, azucar, recolectarMaterial(selva)).
objetivo(salud, alcohol, quimica([fermentizacion, destilacion])).
objetivo(salud, jabon, quimica([mezclarIngredientes, dejarSecar])).
objetivo(salud, botiquin, artesania(5)).

%% También se espera que agreguen más información para los predicados
%% prerrequisito/2 y conseguido/1 para probar lo que necesiten

% prerrequisito(Prerrequisito, Producto)
prerrequisito(almejas, hidroxidoDeCalcio).
prerrequisito(hidroxidoDeCalcio, hidroxidoDeSodio).
prerrequisito(algas, hidroxidoDeSodio).
prerrequisito(hidroxidoDeSodio, jabon).
prerrequisito(grasa, jabon).

prerrequisito(metal, tijera).
prerrequisito(plantaAlgodon, vendaje).
prerrequisito(azucar, alcohol).
prerrequisito(vendaje, botiquin).
prerrequisito(alcohol, botiquin).
prerrequisito(cinta, botiquin).
prerrequisito(tijera, botiquin).
prerrequisito(jabon, botiquin).

% conseguido(Producto)
conseguido(almejas).
conseguido(algas).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 1 %

persona(senku).
persona(chrome).
persona(kohaku).
persona(suika).

puedeRealizar(senku, quimica(_)).
puedeRealizar(chrome, recolectarMaterial(Material)):- Material \= animales.
puedeRealizar(kohaku, recolectarMaterial(animales)).
puedeRealizar(suika, recolectarMaterial(playa)).
puedeRealizar(suika, recolectarMaterial(bosque)).
puedeRealizar(suika, quimica(mezclarIngredientes)).
puedeRealizar(chrome, quimica(Procesos)):- length(Procesos, Cantidad), Cantidad =< 3.
puedeRealizar(senku, artesanias(Dificultad)):- Dificultad =< 6.
puedeRealizar(Persona, artesanias(Dificultad)):- persona(Persona), Dificultad < 3.

% ------- %--------------------------------------------------------------------------------------
% PUNTO 2 %

objetivoFinalProyecto(Proyecto, ObjetivoFinal):-
    objetivo(Proyecto, ObjetivoFinal, _),
    not((prerrequisito(ObjetivoFinal, OtroObjetivo),
         objetivo(Proyecto, OtroObjetivo, _))).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 3 %

tareaRequerida(Tarea):-
    objetivo( _, _ , Tarea).

perteneceAProyecto(Tarea, Proyecto):-
    objetivo(Proyecto, _ , Tarea).

esViable(Proyecto):-
    persona(Persona),
    forall((tareaRequerida(Tarea), objetivo(Proyecto, _ , Tarea)),
           puedeRealizar(Persona, Tarea)).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 4 %

esIndispensable(Persona, Objetivo, Proyecto):-
    objetivo(Proyecto, Objetivo ,Tarea),
    persona(Persona),
    forall((persona(OtraPersona),(Persona \= OtraPersona)),
           not((puedeRealizar(OtraPersona, Tarea)))).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 5 %

estaPendiente(Objetivo):-
    not((conseguido(Objetivo))).

prerrequisitosConseguidos(Objetivo):-
    forall(prerrequisito(Prerrequisito, Objetivo),
          not((estaPendiente(Prerrequisito)))).

puedeIniciarse(Objetivo, Proyecto):-
    objetivo(Proyecto, Objetivo ,_),
    estaPendiente(Objetivo),
    prerrequisitosConseguidos(Objetivo).
    
% ------- %--------------------------------------------------------------------------------------
% PUNTO 6 %

tiempoRestante(Proyecto, TiemposEstimados):-
    objetivo(Proyecto, Objetivo, Tarea),
    esViable(Proyecto),
    findall(Tiempos, (tiempoEstimado(Tarea, Tiempos), perteneceAProyecto(Tarea, Proyecto), estaPendiente(Objetivo)), ListaTiempos),
    sum_list(ListaTiempos, TiemposEstimados).
    

%--------------------------------------------------------------------------------------

tiempoEstimado(recolectarMaterial(Material), 3):-
    Material \= mar,
    Material \= cuevas.    

tiempoEstimado(recolectarMaterial(mar), 8).
tiempoEstimado(recolectarMaterial(cuevas), 48).

tiempoEstimado(quimica(Procesos), TiempoEstimado):-
    length(Procesos, CantidadProcesos),
    TiempoEstimado is (CantidadProcesos * 2).

tiempoEstimado(artesanias(TiempoEstimado), TiempoEstimado).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 7 %

% directo
bloqueaAvance(Objetivo, OtroObjetivo) :-
    prerrequisito(Objetivo, OtroObjetivo).

% indirecto
bloqueaAvance(Objetivo, Otro) :-
    prerrequisito(Objetivo, Otro),
    bloqueaAvance(Otro, _).

objetivoCostoso(Objetivo):-
    objetivo(_, Objetivo, Tarea),
    tiempoEstimado(Tarea, Tiempo),
    Tiempo > 5.

esCritico(Objetivo, Proyecto):-
    objetivo(Proyecto, Objetivo, _),
    objetivoCostoso(Objetivo),
    bloqueaAvance(Objetivo, _).

% ------- %--------------------------------------------------------------------------------------
% PUNTO 8 %

leConvieneTrabajar(Persona, Objetivo):-
    objetivo(Proyecto, Objetivo, Tarea),
    puedeIniciarse(Objetivo, Proyecto),
    esViable(Proyecto),
    puedeRealizar(Persona,Tarea),
    esValioso(Persona, Objetivo).

esValioso(Persona, Objetivo):-
    objetivo(Proyecto, Objetivo, _),
    esIndispensable(Persona, Objetivo, Proyecto).

esValioso(Persona,Objetivo):-
  objetivo(Proyecto, Objetivo,Tarea),
  puedeRealizar(Persona,Tarea),
  tiempoEstimado(Tarea,TiempoDelObjetivo),
  tiempoRestante(Proyecto,TiempoRestante),
  TiempoDelObjetivo > TiempoRestante // 2.

/* esValioso(Persona, Objetivo) :-
    objetivo(Proyecto, Objetivo,Tarea),
    puedeRealizar(Persona,Tarea),
	esCritico(Objetivo, Proyecto),
    forall((puedeIniciarse(Proyecto, OtroObjetivo), OtroObjetivo \= Objetivo),
           (loPuedeHacerOtraPersona(Persona, OtroObjetivo))). */
	
loPuedeHacerOtraPersona(Persona, OtroObjetivo):-
	objetivo(_,OtroObjetivo,OtraTarea),
  puedeRealizar(OtraPersona,_),
  OtraPersona \= Persona,
	puedeRealizar(OtraPersona,OtraTarea).
