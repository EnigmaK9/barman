// ViewController.swift

import UIKit

class ViewController: UIViewController {
    let internetMonitor = InternetMonitor.shared
    let imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupActivityIndicator()
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

    func setupImageView() {
        imageView.frame = self.view.bounds
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }

    func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    func loadImage() {
        activityIndicator.startAnimating()
        let imageURLString = "http://janzelaznog.com/DDAM/iOS/drinksimages/1.jpg"
        if let url = URL(string: imageURLString) {
            // Extract the image name from the URL
            let imageName = url.lastPathComponent
            
            // Use getImage to retrieve the image
            DataManager.shared.getImage(for: imageName) { [weak self] image in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    if let image = image {
                        self?.imageView.image = image
                    } else {
                        // Handle the error (e.g., display an alert or placeholder image)
                        self?.imageView.image = UIImage(named: "placeholder")
                        let alert = UIAlertController(title: "Error", message: "Failed to load image.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
}
