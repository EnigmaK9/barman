//
//  DataManager.swift
//  RemoteData
//
//  Created by Carlos Padilla on 26/10/2024
//

import Foundation

class DataManager:NSObject {
    /*  PATRON SINGLETON  */
    // variable única compartida
    static let shared = DataManager()
    // para que no se pueda instanciar, hay que volver privado el constructor
    private override init() {
        // cualquier código que se necesite ejecutar al crear la variable única
        super.init()
    }
    
    func guardaImagen (_ unaURL:URL) {
        // esto no debe usarse para descargar contenido de Internet, porque bloquea el hilo principal
        //let losBytes = Data(contentsOf: unaURL)
        if let urlDocumentos = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
            let urlDelArchivo = urlDocumentos.appending(component:unaURL.lastPathComponent)
            // comprobar si un archivo ya existe, para no descargarlo dos veces
            if !FileManager.default.fileExists(atPath: urlDelArchivo.path) {
                let sesion = URLSession(configuration: .default)
                let tarea = sesion.dataTask(with:URLRequest(url: unaURL)) { data, response, error in
                    if error != nil {  // let _ = error (MUY swifty)
                        // algo salió mal
                        print ("no se pudo descargar la imagen \(error?.localizedDescription ?? "")")
                        return
                    }
                    // obtener la url de documents:
                    do {
                        try data?.write(to: urlDelArchivo)
                    } catch {
                        print ("no se pudo guardar la imagen")
                    }
                }
                tarea.resume()
            }
        }
    }
}
