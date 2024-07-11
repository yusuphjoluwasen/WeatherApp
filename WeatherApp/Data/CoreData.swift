//
//  CoreData.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import CoreData

/// `CoreDataManager`: A singleton class for managing Core Data stack.
///
/// This class provides a shared instance for managing the Core Data stack, including the persistent container and the main context.
class CoreDataManager {
    /// The shared instance of `CoreDataManager`.
    static let shared = CoreDataManager()
    
    /// The persistent container for the Core Data stack.
    let persistentContainer: NSPersistentContainer

    /// Initializes the `CoreDataManager` with a specified persistent container.
    ///
    /// - Parameter persistentContainer: The `NSPersistentContainer` to use for the Core Data stack.
    ///
    init(persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "WeatherDataModel")) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    /// The main context for performing Core Data operations.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

