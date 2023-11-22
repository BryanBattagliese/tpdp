// SUEÑOS //

class SuenioNoRealizable inherits Exception{}

////////////////////////////

class Persona {

	const property tipoDePersona
	
	var property suenios = #{}
	var property carrerasEstudiadas = #{}
	var property carrerasPendientes = #{}
	var property lugaresVisitados = #{}
	
	const property plataAGanar
	var property hijos
	var property felicidad
		
	method listaDeSueniosPendientes(){
		return suenios.filter({suenio => ! suenio.estaCumplido()})
	}
	
	method sumarFelicidad(cant){
		felicidad += cant
	}
	
	method esFeliz() =
		felicidad > ((self.listaDeSueniosPendientes()).sum({suenio => suenio.felicidonios()}))
	
	method esAmbiciosa() =
		(self.sueniosAmbiciosos()).size() > 3
	
	method sueniosAmbiciosos() =
		suenios.filter({suenio => suenio.felicidonios() > 100})
	
	
	method cumplirSuenioElegido() {
		const suenioElegido = tipoDePersona.elegirSuenio(self.listaDeSueniosPendientes())
		return self.cumplir(suenioElegido)
	}
	
	method cumplir(suenio) =
		suenio.cumplir()
	
////////////////////////////////////////////////////

	method quiereEstudiar(carrera) =
		carrerasPendientes.contains(carrera)
	
	method yaEstudio(carrera) =
		carrerasEstudiadas.contains(carrera)
	
	method completarCarrera(carrera){
		carrerasEstudiadas.add(carrera)
		carrerasPendientes.remove(carrera)
	}
	
////////////////////////////////////////////////////

	method sueldoOfrecidoSatisface(sueldo) =
		sueldo >= plataAGanar			

	method tomarTrabajo(trabajo){
		
	}

////////////////////////////////////////////////////

	method tieneHijos() =
		hijos > 0
	
	method agregarHijos(cantidad){
		hijos += cantidad
	}
	
////////////////////////////////////////////////////
	
	method viajarA(lugar){
		lugaresVisitados.add(lugar)
	}
	
}

class Suenio{
	
	var property cumplido = false
	
	method estaCumplido() = cumplido
	
	method cumplir(persona){
		self.validar(persona)
		self.realizar(persona)
		self.cumplir()
		persona.sumarFelicidad(self.felicidonios())
	}
	
	method cumplir(){cumplido = true}
	method validar(persona)
	method realizar(persona)
	
	method felicidonios()
	
}

class SuenioSimple{
	
	var property felicidonios
	method felicidonios() = felicidonios
	
}

class RecibirseDeUnaCarrera inherits SuenioSimple{
	
	const property carrera
	
	method validar(persona){
		if(! persona.quiereEstudiar(carrera) || persona.yaEstudio(carrera))
			throw new SuenioNoRealizable (message = "EL SUENIO NO SE PUEDE CUMPLIR")

	}
	
	 method realizar(persona){
		persona.completarCarrera()
	}
	
}

class Trabajo inherits SuenioSimple{
	
	const property sueldoOfrecido
	
	 method validar(persona){
		if(!persona.sueldoOfrecidoSatisface(sueldoOfrecido))
			throw new SuenioNoRealizable (message = "EL SUENIO NO SE PUEDE CUMPLIR")
	}

	 method realizar(persona){
		
	}
	
}

class Hijos inherits SuenioSimple{
	
	const property hijos
	
	 method validar(persona){
		if(!persona.tieneHijos())
			throw new SuenioNoRealizable (message = "EL SUENIO NO SE PUEDE CUMPLIR")
	
	}
	
	 method realizar(persona){
		persona.agregarHijos(hijos)
	}
}

class Viajar inherits SuenioSimple{
	
	const property lugar
	
	 method validar(persona){
		
	}
	
	 method realizar(persona){
		persona.viajarA(lugar)
	}
	
}

////////////////////////////////////////////////////

class SuenioCompuesto inherits Suenio {
	
	const property suenios = []
	
	override method validar(persona) =
		suenios.forEach({suenio => suenio.validar(persona)})
	
	override method realizar (persona){
		suenios.forEach({suenio => suenio.realizar(persona)})
	}
	
	override method felicidonios(){
		suenios.sum({suenio => suenio.felicidonios()})
	}
	
}

////////////////////////////////////////////////////

object realista { 
	method elegirSuenio(sueniosPendientes) {
		sueniosPendientes.max { suenio => suenio.felicidonios() }
	}
}

object alocado {
	method elegirSuenio(sueniosPendientes) {
		sueniosPendientes.anyOne()
	}
}

object obsesivo {
	method elegirSuenio(sueniosPendientes) {
		sueniosPendientes.first()
	}
}

