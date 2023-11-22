/* 

	POKEMON
	* Lista de movimientos
	* Salud
	* Salud max
	* Paralisis
	* Sueño

	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	GROSITUD:
	* Para analizar un atributo de los componentes de una clase, uso una lambda
	* En este caso, es para analizar el poder de cada movimiento y sumarlos.
	* Grositud es de consulta: cual es la grositud de 'x' POKEMON (al usar el =)
 
 */
 
///////////////////////////////////
///////////// POKEMON /////////////
///////////////////////////////////

class Pokemon {
	
	var property salud   = 80
	const property vidaMax = 100
	const property movimientos = []
	var property condicion = normal
	
	method grositud() = (vidaMax * movimientos.sum({movimiento => movimiento.poder()}))
	
	method recibirDanio(cantidad){
		salud = (salud - cantidad).max(0)
	}
	
	method recibirCuracion(cantidad){
		salud = (salud + cantidad).min(vidaMax)
	}
 
	method lucharContra(contrincante){
		
		self.validarVida()
		contrincante.validarVida()
		const movimientoAUsar = self.movimientoDisponible()
		
		condicion.intentaMoverse(self)
		
		movimientoAUsar.usarEntre(self, contrincante)
		
	}
		
	method movimientoDisponible() = movimientos.find{mov => mov.estaDisponible()}
	
	method normalizarse(){condicion = normal}
	
	method validarVida(){
		if(salud == 0) throw new NoTieneVidaException(message = "El pokemon esta muerto")
	}

}

///////////////////////////////////
/////////// MOVIMIENTOS ///////////
///////////////////////////////////

class Movimiento {
	var property usosPendientes = 0
	
	method usarEntre(usuario, contrincante){
		if(!self.estaDisponible())
			throw new MovimientoAgotadoException(message = "El Movimiento no esta disponible")
		usosPendientes -= 1
		self.afectarPokemones(usuario,contrincante)
	}
	
	method estaDisponible() = usosPendientes > 0
	
	method afectarPokemones(usuario,contrincante)
	
	method bloquearMovimiento() = not self.estaDisponible() 	
}

class MovimientoCurativo inherits Movimiento {
	
	var property puntosQueCura
	
	method poder() = puntosQueCura

	override method afectarPokemones(usuario,contrincante){
		usuario.recibirCuracion(puntosQueCura)}
	
}

class MovimientoDanino inherits Movimiento {
		
	const danioQueProduce
	
	method poder() = 2 * danioQueProduce
	
	override method afectarPokemones(usuario,contrincante){
		contrincante.recibirDanio(danioQueProduce)
	}
	
	
}

class MovimientoEspecial inherits Movimiento {
	
	var property condicionQueGenera
	
	method poder() = condicionQueGenera.poder()

	override method afectarPokemones(usuario,contrincante){
		contrincante.condicion(condicionQueGenera)
	}
}

///////////////////////////////////
/////////// CONDICIONES ///////////
///////////////////////////////////

class CondicionEspecial{
	
	method intentaMoverse(pokemon){
		if(!self.lograMoverse()) self.error("No puede moverse")
	}
	
	method lograMoverse() = 0.randomUpTo(2).roundUp().even()
	
	method poder()
}

object normal {
	method intentaMoverse(pokemon){}
}

object suenio inherits CondicionEspecial {
	
	override method poder() = 50
	
	override method intentaMoverse(pokemon) {
		super(pokemon)
		pokemon.normalizarse()
	}
	
}

object paralisis inherits CondicionEspecial {
	
	override method poder() = 30
	
}

class Confusion inherits CondicionEspecial { // TRY, CATCH. VER EN VIDEO 1.19 hs ((EXPLICA COMO FUNCIONA))
	
	var property turnosQueDura = 2
	var property movimientoElegido = "movimiento"
	
	override method poder() = 40 * turnosQueDura
	
	override method intentaMoverse(pokemon){
		
		self.pasoUnTurno(pokemon)
		
		if(!self.lograMoverse()){
			pokemon.recibirDanio(20)
			movimientoElegido.bloquearMovimiento()
		}
	}
	
	method pasoUnTurno(pokemon){
		turnosQueDura -= 1
		if (turnosQueDura == 0){
			pokemon.normalizarse()
		} 
	}
	
}

///////////////////////////////////
////////////EXCEPCIONES////////////
///////////////////////////////////

class MovimientoAgotadoException inherits Exception {}

class NoTieneVidaException inherits Exception{}