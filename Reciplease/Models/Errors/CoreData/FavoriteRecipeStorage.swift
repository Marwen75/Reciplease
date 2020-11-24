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
class FavoriteRecipeStorage {
    
    // MARK: - Properties
    private let objectContext: NSManagedObjectContext
    private let coreDataStack: CoreDataStack
    
    // Calculated propertie to return an array of favorite recipes using a fetchrequest
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
    
    func addFavorite(recipe: RecipeModel, completionHandler: @escaping () -> Void) {
        let favoriteRecipe = FavoriteRecipe(context: objectContext)
        favoriteRecipe.name = recipe.name
        favoriteRecipe.ingredients = recipe.ingredients
        favoriteRecipe.yield = Int64(recipe.yield)
        favoriteRecipe.time = Int64(recipe.time)
        favoriteRecipe.url = recipe.url
        favoriteRecipe.image = recipe.image
        coreDataStack.saveContext()
        completionHandler()
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
    
    func deleteFavorite(named name: String, completionHandler: @escaping () -> Void) {
        let request: NSFetchRequest<FavoriteRecipe> =
            FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchResults = try objectContext.fetch(request)
            fetchResults.forEach { objectContext.delete($0) }
            completionHandler()
        } catch let error as NSError {
            print(error.userInfo)
        }
        coreDataStack.saveContext()
    }
}
