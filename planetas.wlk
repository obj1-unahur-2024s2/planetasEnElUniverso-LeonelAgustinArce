class Persona {
    var edad
    var recursos = 20

    method recursos() = recursos
    method edad() = edad 

    method esDestacado() = edad.between(18, 65) or recursos > 30

    method ganarMonedas(unaCantidad) {
        recursos += unaCantidad
    }
    method gastarMoneda(unaCantidad) {
        recursos = 0.max(recursos - unaCantidad)
    } 
    method cumplirAnio() {
        edad += 1 
    }
}

class Constructor inherits Persona {
    var cantConstrucciones
    const property region
    var property tiempoDeTrabajo 

    override method recursos() = recursos + (10 * cantConstrucciones)

    override method esDestacado() = cantConstrucciones > 5

    method trabajarEnPlaneta(unPlaneta) {
        if (region == "montaña"){
            unPlaneta.agregarConstrucion(new Muralla(longitud = tiempoDeTrabajo / 2))
        }
        if (region == "Costa"){
            unPlaneta.agregarConstruccion(new Museo(superficie = tiempoDeTrabajo, indiceImportancia = 1))
        }
        if(region == "Llanura"){
          if (self.esDestacado()){
            unPlaneta.agregarConstruccion(new Museo(superficie = tiempoDeTrabajo, indiceImportancia = recursos))
          }
          else{
            unPlaneta.agregarConstrucion(new Muralla(longitud = tiempoDeTrabajo / 2))
          }
        }
        if(region == "Desierto"){
            unPlaneta.agregarConstruccion(new Museo(superficie = 10, indiceImportancia = 4))
        }
        self.gastarMoneda(5)
        cantConstrucciones += 1
    } 
} 

class Productor inherits Persona {
    const property tecnicas = [new Cultivo(cantTiempo = 5)]

    method agregarTecnica(unaTecnica) {
        tecnicas.add(unaTecnica)
    }

    method realizarTecnica(unaTecnica) {
        if (tecnicas.contains(unaTecnica))
            self.ganarMonedas(3 * unaTecnica.cantTiempo())
        else 
            self.gastarMoneda(1)
    }

    override method recursos() = recursos * tecnicas.size() 

    override method esDestacado() = super() or tecnicas.size() > 5

    method trabajarEnPlaneta(unPlaneta) {
        if (unPlaneta.personas().contains(self))
            self.realizarTecnica(tecnicas.last())
    }
}

class Tecnica {
    var property cantTiempo
}

class Cultivo inherits Tecnica {
    
}


class Muralla {
    var property longitud
    method valor() = 10 * longitud
}

class Museo {
    var property superficie
    var property indiceImportancia
    
    method valor() = superficie * 5.min(indiceImportancia)
}

class Planeta {
    const property personas = []
    const property construcciones = []

    method agregarConstruccion(unaConstruccion) {
        construcciones.add(unaConstruccion)
    }
    method agregarPersonas(unaPersona) {
        personas.add(unaPersona)
    }

    method conMasRecursos() = personas.max({p => p.recursos()})
    method delegacionDiplomatica() {
        const delegacion = personas.filter{p => p.esDestacado()}
        if (!personas.contains(self.conMasRecursos()))
            delegacion.add(self.conMasRecursos())
        return delegacion
    } 

    method esValioso() = construcciones.sum{c => c.valor()} > 100
}