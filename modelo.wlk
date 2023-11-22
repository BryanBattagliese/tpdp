class Imperio {
	
	const property ciudades = []
	var property dinero = 0
	
	method estaEndeudado() = dinero < 0
	
	method agregarIngresos(ingresosGenerados) {
		dinero += ingresosGenerados
	}
	
	method pagar(cantidadDeDinero){
		dinero -= cantidadDeDinero
	}
	
	method puedePagarEdificio(ciudad, edificio) = dinero > ciudad.costoConstruccionEdificio(edificio)
	
	method construirEdificio(ciudad, edificio) {
		if(!self.puedePagarEdificio(ciudad, edificio)) self.error("No se puede construir el edificio")
		else {
			self.pagar(ciudad.costoConstruccionEdificio(edificio))
			ciudad.agregarEdificio(edificio)
		}
	}
	
	method evolucionarImperio(){
		ciudades.forEach({ciudad=>ciudad.evolucionarCiudad()})
	}
	
	method estaDentroDeLas3CiudadesMasFelicesQueMenosCulturaTienen(ciudad) {
		return ciudades.filter({ciudad1=>ciudad1.esFeliz()}).sortedBy({ciudad1,ciudad2 => ciudad1.cultura()<ciudad2.cultura()}).take(3).contains(ciudad)  
		//				filtro segun si son felices | 		ordeno de menor a mayor cultura 				|	tomo los primeros 3	| me fijo si esta la ciudad
		
	}
}

class Ciudad {
	
	const property edificios = []
	var property tanques = 0 // probablemente se pueda calcular con informacion de los puntos que siguen y no hace falta que sea una propiedad
	const property imperio
	var property sistemaImpositivo
	var property cantidadHabitantes = 0

	method tranquilidad() = edificios.sum({edificio => edificio.tranquilidadQueGenera()})
	method cultura() = edificios.sum({edificio => edificio.culturaQueGenera()})
	method disconformidad() = cantidadHabitantes.div(10000) + (30.min(tanques))
	
	method incrementarTanques(cantidadDeTanques) {
		tanques =+ cantidadDeTanques
	}
	
	method esFeliz() = (!imperio.estaEndeudado()) && (self.disconformidad() < self.tranquilidad())
	
	method costoConstruccionEdificio(edificio) = self.sistemaImpositivo().costoDeConstruccionSegunSistema(self, edificio)
	method costoDeMantenimientoEdificio(edificio) = self.costoConstruccionEdificio(edificio) * 0.01
	
	method agregarEdificio(edificio){
		edificios.add(edificio)
	}
	
	method evolucionarCiudad(){
		if (self.esFeliz()) cantidadHabitantes += cantidadHabitantes * 0.02
		self.evolucionarEdificios()
	}
	
	method evolucionarEdificios(){
		edificios.forEach({edificio=>imperio.pagar(self.costoDeMantenimientoEdificio(edificio))
			imperio.agregarIngresos(edificio.dineroQueGenera())	
			self.incrementarTanques(edificio.tanquesQueGenera())				
		})
	}
}

class Capital inherits Ciudad{
	override method disconformidad() = super()/2
	
	override method costoConstruccionEdificio(edificio)= super(edificio) * 1.1  // falta agregar que triplica ingresos
	
	override method evolucionarEdificios(){
		edificios.forEach({edificio=>imperio.pagar(self.costoDeMantenimientoEdificio(edificio))
			imperio.agregarIngresos(edificio.dineroQueGenera()*3)
			self.incrementarTanques(edificio.tanquesQueGenera())				
		})
	}// revisar

	override method evolucionarCiudad(){
		super()
		if (!self.esFeliz()){ self.sistemaImpositivo(apaciguador)}
		else if (self.esFeliz() && imperio.estaDentroDeLas3CiudadesMasFelicesQueMenosCulturaTienen(self)){ 	
			self.sistemaImpositivo(incentivoCultural)
		}
		else self.sistemaImpositivo(new Citadino(cadaXHabitantes=25000))
		
		
	}

}

class Edificio {
	const property costoDeConstruccionBase
	
	method culturaQueGenera() 
	method tranquilidadQueGenera()
	method tanquesQueGenera()
	method dineroQueGenera()
	
}

class EdificioEconomico inherits Edificio {
	const incrementoDinero
	
	override method dineroQueGenera() = incrementoDinero
	override method tranquilidadQueGenera() = 3
}

class EdificioCultural inherits Edificio {
	const culturaIrradiada

	override method culturaQueGenera() = culturaIrradiada
	override method tranquilidadQueGenera() = 3 * culturaIrradiada
}

class EdificioMilitar inherits Edificio {
	const incrementoTanques
	
	override method tanquesQueGenera() = incrementoTanques
}

class Citadino {
	var property cadaXHabitantes
	method costoDeConstruccionSegunSistema(ciudad, edificio) = edificio.costoDeConstruccionBase() + ((5/100) * ciudad.cantidadHabitantes())/cadaXHabitantes
}

object incentivoCultural {
	method costoDeConstruccionSegunSistema(ciudad, edificio) = edificio.costoDeConstruccionBase() - (edificio.culturaQueGenera() / 3)
}

object apaciguador {
	method costoDeConstruccionSegunSistema(ciudad, edificio) {
		if(ciudad.esFeliz()) return edificio.costoDeConstruccionBase()
		else return edificio.costoDeConstruccionBase() - edificio.tranquilidadQueGenera()
	}
}

// Uso composicion para modelar el sistema impositivo
