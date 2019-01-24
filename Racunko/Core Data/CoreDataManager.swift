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
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
        let client = Client(context: context)
        client.address = company.address
        client.city = company.city
        client.name = company.name
        client.oib = Int64(company.oib)
        client.zip = Int16(company.zip)
        saveContext()
    }
    
    func getClients() -> [Client] {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        return result
    }
    
    /// Insert new Invoice for Client
    func addInvoice(_ invoiceModel: InvoiceModel, for client: Client) {
        let invoice = Invoice(context: context)
        invoice.number = invoiceModel.number
        invoice.totalAmount = invoiceModel.amount
        invoice.createdAt = invoiceModel.createdAt
        invoice.date = invoiceModel.date
        invoice.client = client
        
        invoiceModel.invoiceItems.forEach { invoiceItemModel in
            let invoiceItem = InvoiceItem(context: context)
            invoiceItem.title = invoiceItemModel.description
            invoiceItem.amount = Int16(invoiceItemModel.amount)
            invoiceItem.price = invoiceItemModel.price
            invoiceItem.totalPrice = invoiceItemModel.totalAmount
            invoice.addToInvoiceItems(invoiceItem)
        }
        saveContext()
    }
    
    /// Delete invoice
    func deleteInvoice(_ invoice: Invoice) {
        context.delete(invoice)
        saveContext()
    }
    
    /// Get list of invoices by Client
    func getInvoices(for client: Client) -> [Invoice] {
        let fetchRequest: NSFetchRequest<Invoice> = Invoice.fetchRequest()
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        return result
    }
    
    /// Insert Business info
    func addBusiness(_ business: BusinessModel) {
        // delete all before inserting new one, in order to store only one business info
        deleteAllBusiness()
        
        let businessCoreData = Business(context: context)
        businessCoreData.id = UUID()
        businessCoreData.address = business.address
        businessCoreData.bankName = business.bankName
        businessCoreData.defaultFootNote = business.defaultFootNote
        businessCoreData.defaultPaymentType = business.defaultPaymentType
        businessCoreData.email = business.email
        businessCoreData.iban = business.iban
        businessCoreData.name = business.name
        businessCoreData.oib = Int64(business.oib ?? 0)
        businessCoreData.web = business.web
        businessCoreData.bankName = business.bankName
        businessCoreData.phone = business.phone
        businessCoreData.zipCity = business.zipCity
        saveContext()
    }
    
    /// Delete all 'Business' from table
    func deleteAllBusiness() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Business.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error: \(error)")
        }
    }
    
    /// Get All Business
    func getBusiness() -> [Business] {
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        return result
    }
}
