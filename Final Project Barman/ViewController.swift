// ViewController.swift
//
//  ViewController.swift
//  RemoteData
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    let internetMonitor = InternetMonitor()
    let webView = WKWebView()
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
       super.viewDidLoad()
       webView.frame = self.view.bounds
       self.view.addSubview(webView)
       self.view.addSubview(activityIndicator)
       activityIndicator.hidesWhenStopped = true
       activityIndicator.center = view.center
       webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       var message = "No connection"
       if internetMonitor.hasConnection {
           message = "Internet connection is available"
           if internetMonitor.isConnectionWiFi {
               loadImage()
           } else {
               message += " but only via cellular data"
               let alertController = UIAlertController(title: "Hello", message: message, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                   self.loadImage()
               }
               alertController.addAction(okAction)
               let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
               alertController.addAction(cancelAction)
               self.present(alertController, animated: true)
           }
       } else {
           let alertController = UIAlertController(title: "Hello", message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default)
           alertController.addAction(okAction)
           self.present(alertController, animated: true)
       }
    }

    func loadImage() {
       activityIndicator.startAnimating()
       /*
       if let url = URL(string: "http://example.com/data.xlsx") {
           // To open the browser on the device
           // Check if the URL can be opened
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url)
           }
       }
       */
       if let url = URL(string: "https://apod.nasa.gov/apod/image/2410/241010_eggleston_1024.jpg") {
           // To display content in the app, a WKWebView object is used
           let request = URLRequest(url: url)
           webView.load(request)
           DataManager.shared.saveImage(url)
       }
    }
}

// The extension allows methods and properties to be added to a class without having to inherit and replace classes in the code
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       self.activityIndicator.stopAnimating()
    }
}
