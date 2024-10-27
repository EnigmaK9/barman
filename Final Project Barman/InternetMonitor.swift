//
//  InternetMonitor.swift
//  RemoteData
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//

import Foundation
import Network

class InternetMonitor {
    // Decidir si me sirve que sea un singleton
    var hayConexion = false
    var tipoConexionWiFi = false
    private var monitor = NWPathMonitor()
    
    init() {
        // que debe de hacer cuando cambie el estado de la conexion...
        monitor.pathUpdateHandler = { ruta in
            self.hayConexion = ruta.status == .satisfied
            self.tipoConexionWiFi = ruta.usesInterfaceType(.wifi)
        }
        // para que comienze a revisar si hay cambios...
        // los procesos que pueden tomar mucho tiempo o muchos recursos se DEBEN mandar a background
        monitor.start(queue:DispatchQueue.global(qos: .background))
    }
}
