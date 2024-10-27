//
//  DataManager.swift
//  Project Barman
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//
//  Description: The DataManager class handles data management, including drink data and image retrieval, and persists user drinks using Core Data. It also manages downloading and caching images from a remote source.
//
//  Created for: Enigma Unit
//  Version: 1.0.0
//  Copyright © 2024 Enigma Unit. All rights reserved.
//




// The Foundation, Core Data, and UIKit frameworks are imported.
// Foundation provides basic functionalities for apps, Core Data is used for data persistence, and UIKit is used to handle images.
import Foundation
import CoreData  // Import Core Data to manage persistent storage
import UIKit     // Import UIKit for handling images

// The DataManager class is declared. It is responsible for handling data, including drinks and images.
// It inherits from NSObject because it interacts with UIKit and Core Data.
class DataManager: NSObject {

    // A shared static instance of DataManager is created.
    // This allows global access to DataManager using this instance (singleton pattern).
    static let shared = DataManager()

    // The initializer is marked as private to ensure that the class cannot be instantiated from outside.
    // 'super.init()' is called to initialize NSObject.
    private override init() {
        super.init()
        // Fetches user drinks from Core Data when the DataManager is initialized.
        fetchDrinksFromCoreData()
    }

    // Two arrays are declared to hold drinks: 'downloadedDrinks' for fetched drinks and 'userDrinks' for user-added drinks.
    var downloadedDrinks: [Drink] = []
    var userDrinks: [Drink] = []

    // The 'drinks' computed property is defined to return a combination of both downloaded and user drinks.
    // This provides a unified list of all drinks.
    var drinks: [Drink] {
        return downloadedDrinks + userDrinks
    }

    // A persistent container is lazily initialized to manage Core Data.
    // The persistent container is responsible for loading and saving data to and from Core Data.
    lazy var persistentContainer: NSPersistentContainer = {
        // The container is created using the "BarmanDataModel" name, which should match the Core Data model file.
        let container = NSPersistentContainer(name: "BarmanDataModel")
        container.loadPersistentStores { _, error in
            // If an error occurs while loading the persistent store, it is handled by printing the error.
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // A function is defined to download drink data from a remote JSON endpoint.
    // The completion handler is used to return the drinks once they are downloaded.
    func downloadDrinksData(completion: @escaping ([Drink]?) -> Void) {
        // The URL of the drinks JSON is defined.
        if let url = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") {
            // A URLSession is used to download the data asynchronously.
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                // If an error occurs during the download, it is printed, and the completion is called with 'nil'.
                if let error = error {
                    print("Error downloading drink data: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                // If data is received, it is decoded into Drink objects using JSONDecoder.
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        // The downloaded drinks are decoded from the JSON data and stored in the 'downloadedDrinks' array.
                        let downloadedDrinks = try decoder.decode([Drink].self, from: data)
                        // The main thread is used to update the UI and return the downloaded drinks.
                        DispatchQueue.main.async {
                            self?.downloadedDrinks = downloadedDrinks  // The downloaded drinks array is updated.
                            completion(self?.drinks)  // The combined drinks array is returned.
                        }
                    } catch {
                        // If decoding fails, the error is printed, and the completion is called with 'nil'.
                        print("Error decoding drink data: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            }
            // The data task is started to begin the download.
            task.resume()
        }
    }

    // A function is defined to retrieve an image for a drink, either from local storage or by downloading it.
    // The completion handler returns the image once it is retrieved.
    func getImage(for imageName: String, completion: @escaping (UIImage?) -> Void) {
        // If the image name is empty, 'nil' is returned immediately.
        if imageName.isEmpty {
            completion(nil)
            return
        }

        // The documents directory URL is retrieved, which stores files locally.
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // The full path to the image file is created by appending the image name to the documents directory URL.
            let fileURL = documentsURL.appendingPathComponent(imageName)
            // It is checked if the image exists locally.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                // If the image exists, it is loaded from the file system.
                let image = UIImage(contentsOfFile: fileURL.path)
                // The image is returned through the completion handler.
                completion(image)
            } else {
                // If the image does not exist locally, it is downloaded.
                downloadImage(imageName: imageName) { success in
                    // After downloading, the image is retrieved and returned if successful.
                    if success {
                        let image = UIImage(contentsOfFile: fileURL.path)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            // If the documents directory could not be found, 'nil' is returned.
            completion(nil)
        }
    }

    // A private function is defined to download an image from a remote server.
    // The completion handler returns 'true' if the image was downloaded and saved successfully.
    private func downloadImage(imageName: String, completion: @escaping (Bool) -> Void) {
        // The full URL of the image is created using the image name.
        let urlString = "http://janzelaznog.com/DDAM/iOS/drinksimages/\(imageName)"
        if let url = URL(string: urlString) {
            // A URLSession is used to download the image data asynchronously.
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                // If an error occurs, it is printed, and the completion handler returns 'false'.
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                // If image data is received, it is saved locally.
                if let data = data,
                   let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = documentsURL.appendingPathComponent(imageName)
                    do {
                        // The image data is written to the local file system.
                        try data.write(to: fileURL)
                        completion(true)
                    } catch {
                        // If writing the data fails, the error is printed, and 'false' is returned.
                        print("Error saving image: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()  // The data task is started.
        } else {
            completion(false)
        }
    }

    // MARK: - Core Data Methods

    // A function is defined to fetch drinks from Core Data.
    func fetchDrinksFromCoreData() {
        let context = persistentContainer.viewContext  // The Core Data context is retrieved.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DrinkEntity")
        do {
            // The fetch request is performed, and the results are mapped to Drink objects.
            let drinkEntities = try context.fetch(fetchRequest)
            userDrinks = drinkEntities.map { entity in
                Drink(
                    name: entity.value(forKey: "name") as? String ?? "",
                    ingredients: entity.value(forKey: "ingredients") as? String ?? "",
                    directions: entity.value(forKey: "directions") as? String ?? "",
                    img: entity.value(forKey: "img") as? String ?? ""
                )
            }
        } catch {
            // If an error occurs while fetching, it is printed.
            print("Error fetching drinks from Core Data: \(error.localizedDescription)")
        }
    }

    // A function is defined to add a user drink to Core Data.
    func addUserDrink(_ drink: Drink) {
        let context = persistentContainer.viewContext  // The Core Data context is retrieved.
        let drinkEntity = NSEntityDescription.insertNewObject(forEntityName: "DrinkEntity", into: context)
        // The drink's properties are set in the Core Data entity.
        drinkEntity.setValue(drink.name, forKey: "name")
        drinkEntity.setValue(drink.ingredients, forKey: "ingredients")
        drinkEntity.setValue(drink.directions, forKey: "directions")
        drinkEntity.setValue(drink.img, forKey: "img")
        do {
            // The context is saved, and the user's drinks are updated.
            try context.save()
            fetchDrinksFromCoreData()  // The userDrinks array is updated with the newly added drink.
        } catch {
            // If saving the drink fails, the error is printed.
            print("Error saving user drink to Core Data: \(error.localizedDescription)")
        }
    }
}
