//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import CoreData

// An object that will manage the core data stack and saving support
class CoreDataStack {
    
    // MARK: - Properties
    static let modelName = "Reciplease"
    
    init() {
    }
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext(forContext context: NSManagedObjectContext) {
            if context.hasChanges {
                context.performAndWait {
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        print("Error when saving !!! \(nserror.localizedDescription)")
                        print("Callstack :")
                        for symbol: String in Thread.callStackSymbols {
                            print(" > \(symbol)")
                        }
                    }
                }
            }
        }
}
