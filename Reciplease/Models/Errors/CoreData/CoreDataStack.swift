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
                print(error.userInfo)
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch let nserror as NSError {
            print(nserror.userInfo)
        }
    }
}
