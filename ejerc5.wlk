// PARCIAL: Telefonía //
/*

 1. Costo de un consumo realizado			: linea.costoConsumo(consumo)		¡DONE!
 
 2. Informacion de los consumos  			: linea.promedioConsumos()			¡DONE!
 								   	  		  linea.costoTotalConsumos()		¡DONE!
 
 3. Pack puede satisfacer un consumo		: pack.puedeSatisfacer(consumo)		¡DONE!
 
 4. Agregar un pack a la linea 				: linea.agregarPack(pack)			¡DONE!
 
 5. La linea puede hacer cierto consumo 	: linea.puedeConsumir(consumo)		¡DONE!
 
 6. Realizar un consumo en la linea			: linea.realizarConsumo(consumo)     TODO
 
 7. Agregar packs y limpieza de packs		: linea.limpiarPacks()				¡DONE!
 	
 8. 
 	
 9.
	
 10.
	
*/

//////////////
/// LINEAS ///
//////////////

class Linea {
	
	const property numeroDeTelefono
	var property packs = []
	var property consumosRealizados = []
	const property tipoDeLinea = comun
	
	var property internetDisponible
	var property llamadasDisponibles
	
	method consumosUltimoMes() = 
		consumosRealizados.map({consumo => consumo.consumidoUlt30Dias()})
	
	method consumosEntreFechas(a,b) = 
		consumosRealizados.map({consumo => consumo.consumidoEntre(a,b)})
		
// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // 

	method costoConsumo(consumo){																							// PUNTO 1
		consumo.costo()
	}
	
	method costoFinalPorMes() =																								// PUNTO 2a
		self.consumosUltimoMes().sum({consumo => consumo.costo()})
	
	method costoPromedioConsumos(fechaA, fechaB) = 																			// PUNTO 2b
		self.consumosEntreFechas(fechaA, fechaB).sum({consumo => consumo.costo()}) / (consumosRealizados.size())
	
	method agregarPack(pack){																								// PUNTO 3
		packs.add(pack)
	}
	
	method agregarConsumo(consumo) = consumosRealizados.add(consumo)
	
	method puedeConsumir(consumo) = packs.any({pack => pack.puedeSatisfacer(consumo)})																						// PUNTO 5

	method realizarConsumo(consumo) {
		if (! self.puedeConsumir(consumo)) tipoDeLinea.accionConsumoNoRealizable(self,consumo)
		else self.consumirPack(consumo)
	}
	
	method consumirPack(consumo){
		// el primer pack de los "packs" q pueda realizar consumo
	}
	
	method limpiarPacks() = packs.map({pack => pack.noVaMas()})
}

object platinum {

	method accionConsumoNoRealizable(linea, consumo) {
	}

}

object black {

	method accionConsumoNoRealizable(linea, consumo) {
		linea.sumarDeuda(consumo.costo())
	}

}

object comun {

	method accionConsumoNoRealizable(linea, consumo) {
		self.error("Los packs de la línea no pueden cubrir el consumo.")
	}

}

//////////////
// CONSUMOS //
//////////////

class Consumo {
	
	const property fecha = new Date ()
	
	method costo()
	
	method consumidoEntre(min,max) 	// NOT TODO
	
	method consumidoUlt30Dias() 	// NOT TODO
	
	method esSuficiente()
	
	method realizarConsumo(consumo, linea){
		linea.agregarConsumo(consumo)
	}
}

class ConsumoInternet inherits Consumo {//TODO
	
	const property mbs
	override method costo() = (mbs * 0.10)
	
	method cubiertoInternet()
}

class ConsumoLlamadas inherits Consumo {//TODO
	
	const property segundos
	override method costo() = 1 + (segundos * 0.05)
	
	method cubiertoLlamadas()
	
}

///////////
// PACKS //
///////////

class Pack {
	
	const property cantidad
	var	  property consumos = []
	var   property vigencia
	
	method consumir(consumo){
		consumos.add(consumo)
	}
	
	method consumido() = consumos.sum({consumo => consumo.cantidad()})
	
	method restante() = cantidad - self.consumido()
	
	method puedeSatisfacer(consumo)
	
	method acabado() = self.restante() == 0
	
	method vencido()
	
	method noVaMas() = self.acabado() || self.vencido()

}

class CreditoDisponible inherits Pack {
	
	override method puedeSatisfacer(consumo) = consumo.costo() <= self.restante()
	
}

class MegasLibres inherits Pack{
	
	override method puedeSatisfacer(consumo) = consumo.cubiertoInternet(self)
	
	method puedeGastarMB(cant) = cant <= self.restante()

}

class LlamadasGratis inherits Pack {
	
	override method puedeSatisfacer(consumo) = consumo.cubiertoLlamadas(self)
	
}

class InternetIlimitado inherits Pack{
	
	method puedeGastarMB(cant) = true
	
}

class MBLibresPlusPlus inherits MegasLibres {
	
	override method puedeGastarMB(cant) = super(cant) || cant < 0.1
}
