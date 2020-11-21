//
//  CoreDataStore.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import CoreData
// This object will be the data storage of the app 
class DataStorage {
    
    // MARK: - Properties
    private let objectContext: NSManagedObjectContext
    private let privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private let coreDataStack: CoreDataStack
    
    
    var favoriteRecipes: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let persons = try? self.objectContext.fetch(request) else { return [] }
        return persons
    }
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.objectContext = coreDataStack.viewContext
    }
    
    // MARK: - CRUD
    func addFavorite(name: String, ingredients: [String], yield: Int, time: Int, url: String, image: String) {
        privateMoc.parent = objectContext
        privateMoc.performAndWait {
            let recipe = FavoriteRecipe(context: self.privateMoc)
            recipe.name = name
            recipe.ingredients = ingredients
            recipe.yield = Int64(yield)
            recipe.time = Int64(time)
            recipe.url = url
            recipe.image = image
            coreDataStack.saveContext(forContext: privateMoc)
        }
        coreDataStack.saveContext(forContext: objectContext)
    }
    
    func checkForFavoriteRecipe(named name: String) -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> =
            FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchResults = try objectContext.fetch(request)
            if fetchResults.isEmpty {
                return false
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        return true
    }
    
    func deleteFavorite(named name: String) {
        privateMoc.parent = objectContext
        privateMoc.performAndWait {
            let request: NSFetchRequest<FavoriteRecipe> =
                FavoriteRecipe.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", name)
            do {
                let fetchResults = try self.objectContext.fetch(request)
                fetchResults.forEach { self.objectContext.delete($0) }
            } catch let error as NSError {
                print(error.userInfo)
            }
            coreDataStack.saveContext(forContext: privateMoc)
        }
        coreDataStack.saveContext(forContext: objectContext)
    }
}
