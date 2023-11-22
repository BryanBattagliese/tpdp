// PARCIAL FOR SALE //

/* 
	CLASS ALQUILER:
	* meses de contrato
	* comision del agente

	CLASS VENTA:
	* porcentaje valor inmueble

	............................
	
	CLASS INMUEBLE:
	* tipo (usar composicion para calcular el valor y el plus)
	* tamaño en m2
	* ambientes
	* valor
	* reserva (quien)

	............................
	¿ CLASS CLIENTE:
	* solicitar reserva ?
	............................
	
	1.) empleado.comision(operacion) 		¡¡LISTO!!
	
	2.) inmobiliaria.mejorEmpleado()		¡¡LISTO!! (falta implementar)

	3.) empleado.cerroOperacion()			¡¡LISTO!!
		empleado.problemasCon(otroEmp)
	
	4.)										¡¡LISTO!!
	
	5.)										¡¡LISTO!!
*/

// ........................ //
// ..... INMOBILIARIA ..... //
// ........................ //

class Inmobiliaria {
	
	var property empleados = #{}
	var property porcentajePorVenta
	
	method mejorEmpleadoSegun(criterio) = empleados.max({empleado => criterio.ponderacion(empleado)})
}

object totalComisiones {
	method ponderacion(empleado) = empleado.totalComisiones()
}

object cantidadOperaciones{
	method ponderacion(empleado) = empleado.operacionesCerradas().size()
}

object cantidadReservas{
	method ponderacion(empleado) = empleado.reservas().size()
}

// ........................ //
// ....... EMPLEADO ....... //
// ........................ //

class Empleado {
	
	const property operacionesCerradas = #{}
	const property reservas = #{}
	
	method comision(operacion)  = operacion.comision()
	method totalComisiones()    = operacionesCerradas.sum({operacion => operacion.comision()})
	
	method zonasEnLasQueOpero() = operacionesCerradas.map({operacion => operacion.zona()}).asSet()
	
	method concretoOperacionReservadaPor(otroEmpleado) =
		operacionesCerradas.any({operacion => otroEmpleado.reservo(operacion)})
	
	method reservo(operacion) = reservas.contains(operacion)
	
	method reservar(operacion, cliente){
		operacion.reservarPara(cliente)
		reservas.add(operacion)
	}
	
	method concretarOperacion(operacion, cliente){
		operacion.concretarPara(cliente)
		operacionesCerradas.add(operacion)
	}

	method operoEnMismaZonaQue(otroEmpleado) = self.zonasEnLasQueOpero().any({zona => otroEmpleado.operoEnZona(zona)})
	
	method operoEnZona(zona)= self.zonasEnLasQueOpero().contains(zona)
	
	method problemasCon(otroEmpleado) = self.operoEnMismaZonaQue(otroEmpleado) && 
									   (self.concretoOperacionReservadaPor(otroEmpleado) or otroEmpleado.concretoOperacionReservadaPor(self))
	
}


// ....................... //
// ..... OPERACIONES ..... //		MAS O MENOS: Me perdi con el estado y sus alternativas.
// ....................... //

class Operacion {
	
	const property tipoDeInmueble
	const property empleado
	const property inmueble
	var property estado = disponible
	
	method comision()
	
	method zona() = inmueble.zona()
	
	method reservarPara(cliente){
		estado.reservarPara(self, cliente)
	}
	method concretarPara(cliente){
		estado.concretarPara(self, cliente)
	}
	
	method estado(nuevoEstado){
		estado = nuevoEstado
	}
}

// ........................ //

class EstadoDeOperacion {
	
	method reservarPara(operacion, cliente)
	
	method concretarPara(operacion, cliente){
		self.validarCierrePara(cliente)
		operacion.estado(cerrada)
	}
	
	method validarCierrePara(cliente){}
}

object disponible inherits EstadoDeOperacion{	
	
	override method reservarPara(operacion, cliente){
		//operacion.estado(new Reservada(cliente))
	}

}

class Reservada inherits EstadoDeOperacion{
	
	const clienteQueReservo
	
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar(message = "Ya había una reserva previa")
	}
	
	override method validarCierrePara(cliente){
		if(cliente != clienteQueReservo)
			throw new NoSePudoConcretar(message = "La operación está reservada para otro cliente")
	}
	
}

object cerrada inherits EstadoDeOperacion{
	
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar(message = "Ya se cerró la operación")
	}
	
	override method validarCierrePara(cliente){
		throw new NoSePudoConcretar(message = "No se puede cerrar la operación más de una vez")
	}
}

// ........................ //

class Alquiler inherits Operacion {
	
	const property mesesDeContrato

	override method comision() = (mesesDeContrato * tipoDeInmueble.valor()) / 50000
}

class Venta inherits Operacion {
	
	override method comision() = (1.5 * tipoDeInmueble.valor())		// para mi hay que 'delegar', por ahora lo dejo en 1,5 que dice que es lo actual.

}


// ....................... //
// ...... INMUEBLES ...... //
// ....................... //

class Inmueble {
	
	const property tamanio
	const property ambientes
	const property zona
	
	method valor () = zona.valor()
	
	method validarQuePuedeSerVendido(){}
}

class Casa inherits Inmueble {
	
	const property valorParticular = 750000
	
	override method valor () = valorParticular + super()
}

class PH inherits Inmueble {
	
	override method valor () = (14000 * tamanio).min(500000) + super()
	
}

class Departamento inherits Inmueble {
	
	override method valor () = (350000 * ambientes) + super()
	
}

// ....................... //

class Local inherits Casa {
	var property tipoDeLocal
	
	override method valor() = tipoDeLocal.valor()
	
	override method validarQuePuedeSerVendido(){
		self.error("No se puede vender un local")
	}
}

object galpon{
	
	method valor (valorParticular) = valorParticular * 0.50
	
}

object aLaCalle{
	
	var property montoFijo = 5000
	
	method valor (montoBase) = montoFijo + montoBase
		
}


// ........................ //
// ......... ZONA ......... //
// ........................ //

class Zona {
	
	var property valor
	
	method actualizarValor(newValor){valor = newValor}

}


// ......................... //
// ........ CLIENTE ........ //
// ......................... //

class Cliente {

	const property nombre
}

///////////////////////////////

class NoSePudoReservar inherits Exception{}

class NoSePudoConcretar inherits Exception{}

