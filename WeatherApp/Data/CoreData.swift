//
//  CoreData.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "WeatherDataModel")) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
