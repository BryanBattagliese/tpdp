def ejecuctar_planificacion(lista_de_acciones):
    i = 0  # Índice para la iteración manual de la lista

    while i < len(lista_de_acciones):
        accion, id_accion = lista_de_acciones[i]
        
        if id_accion == 1:  # Si la acción es avanzar_1_celda
            if distancia_a_la_pared() < 20.0 and distancia_a_la_pared() != 0:
                parar()
                # Eliminar las acciones restantes
                lista_de_acciones = lista_de_acciones[:i]
                
                # Solicitar nuevas instrucciones desde la consola
                print("\nSe detectó un obstáculo. Ingrese nuevas instrucciones:")
                print("1- Avanzar una celda")
                print("2- Girar derecha")
                print("3- Girar izquierda")
                print("4- Centrarse")
                print("Ingrese las acciones separadas por comas (por ejemplo: 1,2,3):")
                
                nuevas_instrucciones = input().strip().split(',')
                
                for instruccion in nuevas_instrucciones:
                    if instruccion == '1':
                        lista_de_acciones.append((lambda: avanzar_1_celda(VEL_AVANCE), 1))
                    elif instruccion == '2':
                        lista_de_acciones.append((lambda: girar_der(), 2))
                    elif instruccion == '3':
                        lista_de_acciones.append((lambda: girar_izq(), 3))
                    elif instruccion == '4':
                        lista_de_acciones.append((lambda: centrar(), 4))
                
                # Reiniciar el índice para continuar desde el inicio de las nuevas acciones
                i = 0
                continue
            
            else:
                accion()  # Ejecutar avanzar_1_celda
                mapear()  # Realizar el mapeo solo si la acción es avanzar_1_celda
        
        else:
            accion()  # Ejecutar la acción (girar o centrar) sin mapeo
        
        i += 1

    # Guardar el mapa final y limpiar el archivo de mapeo
    convertir_a_binario(mapeo, 'binario.txt')
    mapa.mapas_finales(mapeo, ultimo_mapa)
    mapa.superponer_mapas(mapeo, ultimo_mapa)
    guardar_mapa_final()
    desconectar()
