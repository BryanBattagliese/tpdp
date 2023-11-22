/* // DANGER ZONE // PUNTO 1 Y 2 DESDE LA PERSPECTIVA DE HERENCIA y R-FACTOR //

	Hicimos un R-Factor: una correccion de herencia a composicion.
 	
 	Objetos es "especialmente bueno ante la incertidumbre"
 	
 	IMPORTANTE ABSTRAER Y DELEGAR ej:(tieneHabilidad) 
	           -------- 	
*/


class Empleado {
	
	var property salud = 100
	var property puesto										// Para cambiar de puesto, solo es necesario cambiar esta variable
	
	const property habilidades = #{}
	
	method saludCritica() = puesto.saludCritica()
	
	method estaIncapacitado() = salud < self.saludCritica()
	
	method tieneHabilidad (habilidad) = habilidades.contains(habilidad)
	
	method puedeUsar(habilidad) = (!self.estaIncapacitado()) && self.tieneHabilidad(habilidad)
	
	// =========================================================================================================================
	
	method recibirDanio(peligrosidad){
		salud -= peligrosidad
	}
	
	method estaVivo()= salud > 0
	
	method finalizarMision(mision){
		if(self.estaVivo()){self.completarMision(mision)}
	}
	
	method completarMision(mision){
		puesto.completarMision(mision, self)
	}

	method aprender(habilidad){
		habilidades.add(habilidad)
	}
}

object puestoEspia {										// SIN ESTADO INTERNO ! ! ! => OBJETO!
	method saludCritica() = 15
	
	method completarMision(mision, empleado){
		mision.habilidadesQueNoPosee(empleado).forEach({hab => empleado.aprender(hab)})
	}
}

class PuestoOficinista {
	var property cantidadEstrellas = 0						// ESTADO INTERNO (cada of debe tener su propias estrellas)! ! ! 
	method saludCritica() = 40 - 5 * cantidadEstrellas
	
	method completarMision(mision){
		cantidadEstrellas += 1
	}
}

class Jefe inherits Empleado {

	const property empleadosACargo = []
	
	method algunSubordinadoLaTiene(habilidad) =
		empleadosACargo.any{subordinado => subordinado.puedeUsar(habilidad)}
	
	override method tieneHabilidad(habilidad) = super(habilidad) or self.algunSubordinadoLaTiene(habilidad)
	
}

// ======================================================

class Mision {
	
	const property habilidadesRequeridas = []
	const property peligrosidad

// ======================================================

	method serCumplidaPor(asignado){
		
		self.validarHabilidades(asignado)
		
		asignado.recibirDanio(peligrosidad)
		
		asignado.finalizarMision(self)
	}

// ======================================================

	method validarHabilidades(asignado){
		if(!self.reuneHabilidadesRequeridas(asignado))
			self.error('La mision no puede ser realizada por este asignado')
	}
	
	method reuneHabilidadesRequeridas(asignado) = 
		habilidadesRequeridas.all({hab => asignado.puedeUsar(hab)})

	method enseniarHabilidades(empleado){
		self.habilidadesQueNoPosee(empleado)
		 	.forEach({hab => empleado.aprender(hab)})
	}
	
	method habilidadesQueNoPosee(empleado) = 
		habilidadesRequeridas.filter({hab => not empleado.tieneHabilidad(hab)})
}

class Equipo {
	const property integrantes = []
	
	method sumarIntegrante(empleado) =
		integrantes.add(empleado)
		
	method puedeUsar(habilidad) = integrantes.any({int => int.puedeUsar(habilidad)})

	method recibirDanio(cantidad){
		integrantes.forEach({emp => emp.recibirDanio(cantidad / 3)})
	}
	
	method finalizarMision(mision){
		integrantes.forEach({emp => emp.finalizarMision(mision)})
	}

}

