// DataManager.swift
//
//  DataManager.swift
//  RemoteData
//
//  Created by Carlos Padilla on 26/10/2024
//

import Foundation

class DataManager: NSObject {
    /* SINGLETON PATTERN */
    // Unique shared instance
    static let shared = DataManager()
    // To prevent instantiation, the constructor is made private
    private override init() {
       // Any code that needs to be executed when the unique instance is created
       super.init()
    }

    func saveImage(_ url: URL) {
       // This should not be used to download content from the Internet, because it blocks the main thread
       // let data = Data(contentsOf: url)
       if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
           let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
           // Check if a file already exists to avoid downloading it twice
           if !FileManager.default.fileExists(atPath: fileURL.path) {
               let session = URLSession(configuration: .default)
               let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
                   if error != nil {
                       // Something went wrong
                       print("Could not download the image \(error?.localizedDescription ?? "")")
                       return
                   }
                   // Write the data to the documents URL
                   do {
                       try data?.write(to: fileURL)
                   } catch {
                       print("Could not save the image")
                   }
               }
               task.resume()
           }
       }
    }
}
