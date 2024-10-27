// ViewController.swift
//
//  ViewController.swift
//  RemoteData
//
//  Created by Carlos Padilla on 26/10/24.
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
                let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.loadImage()
                }
                alertController.addAction(okAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        } else {
            let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }

    func loadImage() {
        activityIndicator.startAnimating()
        if let url = URL(string: "http://janzelaznog.com/DDAM/iOS/drinksimages/1.jpg") {
            // Load content into the WebView
            let request = URLRequest(url: url)
            webView.load(request)
            
            // Extract the image name from the URL
            let imageName = url.lastPathComponent
            
            // Call saveImage with the correct parameter and completion handler
            DataManager.shared.saveImage(imageName) { savedURL in
                if let savedURL = savedURL {
                    print("Image saved at \(savedURL)")
                } else {
                    print("Failed to save image")
                }
            }
        }
    }
}

// Extension to add WKNavigationDelegate methods
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}
