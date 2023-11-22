class Dragon {
	
	var property resistencia 	= 100
	var property velocidadBase  = 50
	
	var property caracter
	
	var property peligrosidad  	= 0
	
	const property habilidades = []
	
	const property raza
	
	method enfrentarseA(otroDragon){
		if(peligrosidad > otroDragon.peligrosidad()){
			self.ganarA(otroDragon)
			otroDragon.perderCon(self)
		}
		
		else {
			otroDragon.ganarA(self)
			self.perderCon(otroDragon)
		}
	}
	
	method ganarA(otroDragon){
		self.aumentarVelocidad(1)
		self.caracter("Agresivo")
		otroDragon.reducirResistencia(1)
	}
	
	method perderCon(otroDragon){
		self.reducirResistencia(1)
		self.caracter("Manso")
		otroDragon.aumentarVelocidad(1)
	}
	
	method reducirResistencia(nro){
		resistencia -= nro
	}
	
	method aumentarVelocidad(nro){
		velocidadBase += nro
	}

	method agregarHabilidades(habilidad){
		habilidades.add(habilidad)	
	}

}

class FuriaNocturna inherits Dragon {
	var property velocidad = velocidadBase * 2
}

  class Gronkle inherits Dragon {
	var property velocidad = velocidadBase / 2
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

object bolaDeFuego {
	var property danio = 100
}

object camuflaje {
	var property danio = 0
}

// ==========================================

class Caracter {
	const property habilidades = []
	
	method peligrosidad(dragon) {
		(habilidades.danio()).sum()
	}
	
	method puedeVolar(kms, dragon) = 
		dragon.resistencia() > (kms / dragon.velocidad()) 
}

// ==========================================

class Equilibrado inherits Caracter {
	
	override method puedeVolar(kms,dragon){
		return true
	}
}

// ==========================================

class Manso inherits Caracter {
	
	override method peligrosidad(dragon) {
		super(dragon).min(10)
	}
	
}

// ==========================================

class Agresivo inherits Caracter {
	
	override method peligrosidad(dragon){
		(super(dragon) * 2) .sum() 				// esta mal, pero es para que no tire error mientras sigo (iria sin el .sum, pero no se pq no anda)
	}
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

