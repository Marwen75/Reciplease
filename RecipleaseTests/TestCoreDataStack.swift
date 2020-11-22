//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 16/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import XCTest
@testable import Reciplease
import CoreData

// A class that inherits from CoreDataStack that will serve within our tests
class TestCoreDataStack: CoreDataStack {

    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores {_, error in
            if let error = error as NSError? {
                fatalError("\(error)")
            }
        }
        persistentContainer = container
    }
}
