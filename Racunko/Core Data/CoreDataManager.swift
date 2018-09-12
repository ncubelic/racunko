//
//  CoreDataManager.swift
//  Racunko
//
//  Created by Nikola on 12/09/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Invoice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Public functions
    
    func addClient(_ company: Company) {
        let client = Client(context: persistentContainer.viewContext)
        client.address = company.address
        client.city = company.city
        client.name = company.name
        client.oib = Int64(company.oib)
        client.zip = Int16(company.zip)
        saveContext()
    }
    
    func getClients() -> [Client] {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        guard let result = try? persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return result
    }
}
