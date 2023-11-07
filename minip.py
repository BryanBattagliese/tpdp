#===================================================
#				GIAR_FRBA_UTN				2023
#     Ing. Pablo D. Folino y Sergio Alberino
#
#  Este programa corre con la escena 
#                   MiniPI_ver12_5x5_circuito_1.ttt
#===================================================
import sim
import simConst
import time
import math
import numpy      as np
import minipi_lib as robot


# en el coppeliaSim debe estar en un script simRemoteApi.start(19997,1000,true,true)

#========================================================
#                       Constantes
VEL_BUSQUEDALINEA = 2         # Velocidad baja 1.5
VEL_AVANCE = 1
VEL_GIRO_DIRECCION = 0.8      # Es la velocidad con que gira
GRADOS_INCERTIDUMBRE = 1.5    # 1.5º
GRADOS_INCERDIDUMBRE_CONSULTA = 5
POS_INCERTIDUMBRE = 0.005     # 0,5 cm
LONG_CELDA = 0.4              # La longitud de la celda es de 40cm
POSICIONES = []

#========================================================
#                      Variables globales
#========================================================
clientID = 0      # Handle del entorno CoppeliaSim
H_floor = 0       # Handle del piso 
                  # Manejadores del robot
H_rueda_Izq = 0
H_rueda_Der = 0
H_uS_adelante = 0
H_uS_atras = 0 
H_uS_der = 0
H_uS_izq = 0
H_minipi = 0
H_linea_izq = 0
H_linea_C_izq = 0
H_linea_der = 0 
H_linea_C_der = 0
#========================================================
#                       Funciones
#========================================================

def mapeador():
    #robot.centrar()
    if(not(robot.get_posicion() in POSICIONES)):
        POSICIONES.append(robot.get_posicion())
        robot.analizarEntorno()
    
    else:
        print('ya estuve aqui :)')



#========================================================
#                 Programa principal
#========================================================

#========================================================

# Pendientes:
# 1- Ver como hacer para que luego de cada instruccion se ejecute el mapeador automaticamente
# 2- Implementar que sucede cuando el minipi vuelve a una posicion que ya estuvo
# 3- A la posicion que me devuelve el minipi, debo agregarle cierto margen de error
# 4- !! Ver como transformar la tabla de 1s y 0s en un "mapa" !!

# CORRECCION A VER COMO IMPLEMENTAR: No deberia yo preguntarle al minipi por su estado actual, el deberia
#                                    (luego de cada instruccion realizada), retornar ese estado.

#========================================================

if robot.conectar():
    
    mapeador()
    
    robot.avanzar_1_celda(VEL_AVANCE)
    mapeador()
    
    robot.girar_der()
    mapeador()
    
    robot.avanzar_1_celda(VEL_AVANCE)
    mapeador()
    
    robot.girar_der()
    mapeador()
    
    robot.avanzar_1_celda(VEL_AVANCE)
    mapeador()
    
    time.sleep(2)
    robot.desconectar()

else:
    print('Nose pudo conectar')
    
	#=========================================================================================  
    # Paro la simuación
    
    sim.simxStopSimulation(clientID, sim.simx_opmode_oneshot)
    # Envío que me desconecto al V-REP
    
    sim.simxAddStatusbarMessage(clientID, 'Se desconectó el programa de control Python', sim.simx_opmode_oneshot)
    print('CoppeliaSim se desconectó')
    time.sleep(2)
    sim.simxFinish(clientID)


##########################################################################################################
#		Algunas funciones de LUA (verificar que coinciden con los handlers del programa Python)
#
#		sim.getObject('/pared')
#		sim.getObject('/MiniPi/u_sonido')
#		sim.checkDistance(32,33,0)                 -----> NO ESTARÍA FUNCIONANDO
#		sim.getObjectOrientation(243,13)  H_u_sonido=243 H_floor=13
#
##########################################################################################################
