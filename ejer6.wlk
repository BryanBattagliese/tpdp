// VIKINGOS //

//========================== Excepciones =========================//

class NoPuedeSubirException inherits Exception {}

class NoAsciendoException inherits Exception {}

class NoValeLaPenaException inherits Exception {}

// ============================================================== //

class Expedicion {
	
	var property vikingos = #{}
	var property objetivosAInvadir = #{}
	
	method puedeSubirAUnaExpedicion(vikingo) =
		vikingo.puedeSubirAUnaExpedicion(self)
	
	method agregarVikingoAExpedicion(vikingo) = 
		vikingos.add(vikingo)
	
	method subirVikingoAExpedicion(vikingo){
		if (!self.puedeSubirAUnaExpedicion(vikingo)) 
			throw new NoPuedeSubirException (message = "Este vikingo no puede subir a la expedicion")
		
		else self.agregarVikingoAExpedicion(vikingo)
	}
	
	method invadirObjetivos(){
		objetivosAInvadir.forEach({objetivo => objetivo.invasion()})
	}
	
	method dividirBotin(botin){
		vikingos.forEach{int => int.ganar(botin / self.cantidadDeVikingos())}
	}
	
	method valeLaPenaLaExpedicion() =
		objetivosAInvadir.all({objetivo => objetivo.valeLaPena(self)})
	
	method cantidadDeVikingos() =
		vikingos.size()
	
}

// = Corregir ======================================================= //

class ObjetivoAInvadir{
	
	method botinPosible(expedicion)
	
	method valeLaPena(expedicion)
	
	method destruccion(cantInvasores)
	
	method serInvadidoPor(expedicion){
		
		self.destruccion(expedicion.vikingos())
		expedicion.dividirBotin(self.botinPosible(expedicion))
		
	}

}

class Capital inherits ObjetivoAInvadir{
	
	var property defensores
	const property riquezaDeLaTierra
	
	method defensoresDerrotados(cantInvasores) = defensores.min(cantInvasores)
	
	override method botinPosible(expedicion) =
		(self.defensoresDerrotados(expedicion)) * riquezaDeLaTierra

	override method valeLaPena(expedicion) =
		self.botinPosible(expedicion) > (3 * (expedicion.cantidadDeVikingos()))
	
	override method destruccion (cantInvasores){
		defensores -= cantInvasores
	}
	
}

class Aldea inherits ObjetivoAInvadir{
	
	var property crucifijos
	
	override method botinPosible(expedicion) =
		crucifijos
	
	override method valeLaPena(expedicion) =
		self.botinPosible(expedicion) > 15
	
	override method destruccion(cantInvasores){
		crucifijos = 0
	}


}

class AldeaAmurallada inherits Aldea {
	
	var minimosVikingos
	
	override method valeLaPena(cantInvasores) = 
		cantInvasores >= minimosVikingos and super(cantInvasores)
	
}

class Defensor {
	
	const property vikingoQueLoDerroto
	
	method estaDerrotado(){
		vikingoQueLoDerroto.matarDefensor(self)
	}
	
}

// ============================================================== //

class Vikingo {
	
	var property casta = karl
	var property monedasDeOro
	
	method esProductivo()
	
	method puedeSubirAUnaExpedicion(expedicion) =
		self.esProductivo() && casta.puedeIr(self, expedicion)
	
	method ascender(){
		
		casta.consecuenciasAscenso(self)
		casta = casta.sucesor()
	
	}
		
	method consecuenciasAscenso()
	
	method agregarMonedas(num){
		monedasDeOro += num
	
	}
	
// ============================================================== //
	
}

class Soldado inherits Vikingo{
	
	var property nroVictimas
	var property armas
	
	method tieneArmas() =
		armas > 0
	
	method matarDefensor(defensor)
	
	override method esProductivo() =
		nroVictimas > 20 && self.tieneArmas()
	
	override method consecuenciasAscenso(){
		armas += 10
	}
	
}

class Granjero inherits Vikingo{
	
	var property nroHijos
	var property hectareas
	
	override method esProductivo() =
		hectareas * 2 > nroHijos
	
	override method consecuenciasAscenso(){
		nroHijos += 2
		hectareas += 2
	}

}

// ============================================================== //

object jarl{
	
	method puedeIr(vikingo, expedicion) =
		!vikingo.tieneArmas()
	
	method sucesor() = karl
	
	method consecuenciasAscenso(vikingo) =
		vikingo.consecuenciasAscenso()
	
}

object karl{
	
	method puedeIr(vikingo, expedicion) = true
	
	method sucesor() = thrall
	
}

object thrall{
	
	method puedeIr(vikingo, expedicion) = true
	
	method sucesor() = throw new NoAsciendoException (message = "No puedo ascender mas")
}





