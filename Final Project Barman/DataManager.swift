// DataManager.swift

import Foundation
import CoreData  // Importar Core Data
import UIKit     // Importar UIKit para manejar imágenes

class DataManager: NSObject {
    static let shared = DataManager()
    private override init() {
        super.init()
        fetchDrinksFromCoreData()  // Cargar las bebidas del usuario
    }

    var downloadedDrinks: [Drink] = []
    var userDrinks: [Drink] = []

    var drinks: [Drink] {
        return downloadedDrinks + userDrinks
    }

    // Contenedor persistente de Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BarmanDataModel")  // Asegúrate de que este nombre coincida con tu modelo
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Manejo de errores
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // Descargar datos de bebidas
    func downloadDrinksData(completion: @escaping ([Drink]?) -> Void) {
        if let url = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("Error al descargar los datos de bebidas: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let downloadedDrinks = try decoder.decode([Drink].self, from: data)
                        DispatchQueue.main.async {
                            self?.downloadedDrinks = downloadedDrinks  // Actualizar las bebidas descargadas
                            completion(self?.drinks)
                        }
                    } catch {
                        print("Error al analizar los datos de bebidas: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }

    // Obtener imagen (carga y cacheo)
    func getImage(for imageName: String, completion: @escaping (UIImage?) -> Void) {
        if imageName.isEmpty {
            completion(nil)
            return
        }

        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                // La imagen existe localmente
                let image = UIImage(contentsOfFile: fileURL.path)
                completion(image)
            } else {
                // Descargar la imagen
                downloadImage(imageName: imageName) { success in
                    if success {
                        let image = UIImage(contentsOfFile: fileURL.path)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }

    private func downloadImage(imageName: String, completion: @escaping (Bool) -> Void) {
        let urlString = "http://janzelaznog.com/DDAM/iOS/drinksimages/\(imageName)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al descargar la imagen: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                if let data = data,
                   let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = documentsURL.appendingPathComponent(imageName)
                    do {
                        try data.write(to: fileURL)
                        completion(true)
                    } catch {
                        print("Error al guardar la imagen: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }

    // MARK: - Métodos de Core Data

    // Obtener bebidas desde Core Data
    func fetchDrinksFromCoreData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DrinkEntity")
        do {
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
            print("Error al obtener las bebidas desde Core Data: \(error.localizedDescription)")
        }
    }

    // Agregar bebida del usuario a Core Data
    func addUserDrink(_ drink: Drink) {
        let context = persistentContainer.viewContext
        let drinkEntity = NSEntityDescription.insertNewObject(forEntityName: "DrinkEntity", into: context)
        drinkEntity.setValue(drink.name, forKey: "name")
        drinkEntity.setValue(drink.ingredients, forKey: "ingredients")
        drinkEntity.setValue(drink.directions, forKey: "directions")
        drinkEntity.setValue(drink.img, forKey: "img")
        do {
            try context.save()
            fetchDrinksFromCoreData()  // Actualizar el array de userDrinks
        } catch {
            print("Error al guardar la bebida del usuario en Core Data: \(error.localizedDescription)")
        }
    }
}
