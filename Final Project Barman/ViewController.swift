//
//  ViewController.swift
//  Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//
//  Description: The main view controller is responsible for displaying an image based on the internet connection status, handling user interaction, and managing the UI elements like image view and activity indicator.
//
//  Created for: Enigma Unit
//  Version: 1.0.0
//  Copyright © 2024 Enigma Unit. All rights reserved.
//
import UIKit

// The ViewController class is responsible for handling the main view of the app.
class ViewController: UIViewController {
    
    // An instance of InternetMonitor is used to check the internet connection status.
    let internetMonitor = InternetMonitor.shared
    
    // The imageView will display the image loaded from a remote URL.
    let imageView = UIImageView()
    
    // The activityIndicator will be shown while the image is being downloaded.
    let activityIndicator = UIActivityIndicatorView(style: .large)

    // viewDidLoad is called when the view controller’s view is loaded into memory.
    // Here, the imageView and activityIndicator are set up.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView() // The imageView is configured and added to the view hierarchy.
        setupActivityIndicator() // The activityIndicator is configured and added to the view hierarchy.
    }

    // viewDidAppear is called when the view is about to appear on the screen.
    // This method checks the internet connection and displays an alert based on the connection status.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // A default message is set to indicate no connection.
        var message = "No connection"
        
        // If an internet connection is detected, the message is updated.
        if internetMonitor.hasConnection {
            message = "Internet connection is available"
            
            // If the connection is WiFi, the image is loaded immediately.
            if internetMonitor.isConnectionWiFi {
                loadImage() // The image is downloaded and displayed.
                
            } else {
                // If the connection is via cellular data, an alert is shown to the user before loading the image.
                message += " but only via cellular data"
                let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
                
                // An "OK" action is added to the alert to load the image after confirmation.
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.loadImage() // The image is loaded after the user confirms.
                }
                alertController.addAction(okAction)
                
                // A "Cancel" action is added to allow the user to cancel the image loading.
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                alertController.addAction(cancelAction)
                
                // The alert is presented to the user.
                self.present(alertController, animated: true)
            }
        } else {
            // If no internet connection is detected, an alert is shown with the default message.
            let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }

    // This method configures the imageView's properties, such as its frame and content mode,
    // and adds it to the main view.
    func setupImageView() {
        imageView.frame = self.view.bounds // The imageView is set to fill the entire view.
        imageView.contentMode = .scaleAspectFit // The image will be scaled to fit within the imageView while maintaining its aspect ratio.
        self.view.addSubview(imageView) // The imageView is added to the view hierarchy.
    }

    // This method configures the activityIndicator's properties and adds it to the main view.
    func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true // The activityIndicator will hide itself when it stops animating.
        activityIndicator.center = view.center // The activityIndicator is placed at the center of the view.
        view.addSubview(activityIndicator) // The activityIndicator is added to the view hierarchy.
    }

    // This method is responsible for downloading the image from a remote URL.
    // It shows the activityIndicator while the image is being fetched.
    func loadImage() {
        activityIndicator.startAnimating() // The activityIndicator is shown while the image is being loaded.
        
        // The URL of the image is defined as a string.
        let imageURLString = "http://janzelaznog.com/DDAM/iOS/drinksimages/1.jpg"
        
        // The string is converted into a URL object.
        if let url = URL(string: imageURLString) {
            // The name of the image file is extracted from the URL.
            let imageName = url.lastPathComponent
            
            // The DataManager is used to retrieve the image from the cache or download it.
            DataManager.shared.getImage(for: imageName) { [weak self] image in
                // The completion handler is executed on the main thread to update the UI.
                DispatchQueue.main.async {
                    // The activityIndicator is stopped once the image has been loaded.
                    self?.activityIndicator.stopAnimating()
                    
                    // If an image was successfully retrieved, it is displayed in the imageView.
                    if let image = image {
                        self?.imageView.image = image
                    } else {
                        // If there was an error loading the image, a placeholder image is shown.
                        self?.imageView.image = UIImage(named: "placeholder")
                        
                        // An alert is shown to notify the user that the image failed to load.
                        let alert = UIAlertController(title: "Error", message: "Failed to load image.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
}
