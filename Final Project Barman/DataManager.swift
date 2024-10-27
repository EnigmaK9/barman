// DataManager.swift

// DataManager.swift

import Foundation
import CoreData  // Import Core Data

class DataManager: NSObject {
    static let shared = DataManager()
    private override init() {
        super.init()
        fetchDrinksFromCoreData()  // Load existing drinks
    }

    var drinks: [Drink] = []

    // Core Data persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BarmanDataModel")  // Replace with your model name
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Handle error appropriately
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // Download drinks data
    func downloadDrinksData(completion: @escaping ([Drink]?) -> Void) {
        if let url = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error downloading drinks data: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let downloadedDrinks = try decoder.decode([Drink].self, from: data)
                        DispatchQueue.main.async {
                            self?.drinks += downloadedDrinks  // Combine with existing drinks
                            completion(self?.drinks)
                        }
                    } catch {
                        print("Error parsing drinks data: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }

    // Save image
    func saveImage(_ imageName: String, completion: @escaping (URL?) -> Void) {
        let urlString = "http://janzelaznog.com/DDAM/iOS/drinksimages/\(imageName)"
        if let url = URL(string: urlString),
           let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                completion(fileURL)
            } else {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    if let data = data {
                        do {
                            try data.write(to: fileURL)
                            completion(fileURL)
                        } catch {
                            print("Error saving image: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                }
                task.resume()
            }
        } else {
            completion(nil)
        }
    }

    // MARK: - Core Data Methods

    // Fetch drinks from Core Data
    func fetchDrinksFromCoreData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DrinkEntity")
        do {
            let drinkEntities = try context.fetch(fetchRequest)
            drinks = drinkEntities.map { entity in
                Drink(
                    name: entity.value(forKey: "name") as? String ?? "",
                    ingredients: entity.value(forKey: "ingredients") as? String ?? "",
                    directions: entity.value(forKey: "directions") as? String ?? "",
                    img: entity.value(forKey: "img") as? String ?? ""
                )
            }
        } catch {
            print("Error fetching drinks from Core Data: \(error.localizedDescription)")
        }
    }

    // Add user drink to Core Data
    func addUserDrink(_ drink: Drink) {
        let context = persistentContainer.viewContext
        let drinkEntity = NSEntityDescription.insertNewObject(forEntityName: "DrinkEntity", into: context)
        drinkEntity.setValue(drink.name, forKey: "name")
        drinkEntity.setValue(drink.ingredients, forKey: "ingredients")
        drinkEntity.setValue(drink.directions, forKey: "directions")
        drinkEntity.setValue(drink.img, forKey: "img")
        do {
            try context.save()
            fetchDrinksFromCoreData()  // Refresh drinks array
        } catch {
            print("Error saving user drink to Core Data: \(error.localizedDescription)")
        }
    }
}

