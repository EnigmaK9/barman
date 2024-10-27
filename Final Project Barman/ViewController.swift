//
//  ViewController.swift
//  RemoteData
//
//  Created by Ángel González on 12/10/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    let internetMonitor = InternetMonitor()
    let webView = WKWebView()
    let solecito = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        self.view.addSubview(solecito)
        solecito.hidesWhenStopped = true
        solecito.center = view.center
        webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var mensaje = "No hay conexión"
        if internetMonitor.hayConexion {
            mensaje = "La conexión a Internet está disponible"
            if internetMonitor.tipoConexionWiFi {
                cargaImagen()
            }
            else {
                mensaje += " pero solo por datos celulares"
                let ac = UIAlertController(title: "hola", message:mensaje, preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style:.default) {
                    alertaction in
                    self.cargaImagen()
                }
                ac.addAction(action)
                let action2 = UIAlertAction(title: "cancelar", style:.destructive)
                ac.addAction(action2)
                self.present(ac, animated: true)
            }
        }
        else {
            let ac = UIAlertController(title: "hola", message:mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style:.default)
            ac.addAction(action)
            self.present(ac, animated: true)
        }
    }
    
    func cargaImagen () {
        solecito.startAnimating()
        /*if let laURL = URL(string:"http://janzelaznog.com/DDAM/iOS/vim/localidades.xlsx") {
         // para abrir el browser en el dispositivo
         // consultar si se puede abrir la URL
         
         if UIApplication.shared.canOpenURL(laURL) {
         UIApplication.shared.open(laURL)
         }
         */
        if let laURL = URL(string:"https://apod.nasa.gov/apod/image/2410/241010_eggleston_1024.jpg") {
            //para mostrar contenido en mi App, usamos un objeto WKWebView
            let elRequest = URLRequest(url: laURL)
            webView.load(elRequest)
            DataManager.shared.guardaImagen(laURL)
        }
    }
}
// la extensión me permite agregar métodos y propiedades a una clase, sin tener que heredarla y reemplazar las clases en el código
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.solecito.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.solecito.stopAnimating()
    }
}
