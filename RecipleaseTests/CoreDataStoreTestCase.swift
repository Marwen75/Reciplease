//
//  CoreDataStoreTestCase.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 16/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import XCTest
@testable import Reciplease
 import CoreData

class CoreDataStoreTestCase: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var coreDataStore: CoreDataStore!

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        coreDataStore = CoreDataStore(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStore = nil
        coreDataStack = nil
    }
    
    func testIfAFavoriteRecipeIsAddedThenTheRecipeShouldAppearInCoreData() {
        coreDataStore.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertTrue(coreDataStore.favoriteRecipes.count == 1)
        XCTAssertTrue(coreDataStore.favoriteRecipes[0].name == "Recette")
    }
    
    func testIfAFavoriteIsDeletedThenTheRecipeShouldNotAppearInCoreData() {
        coreDataStore.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        coreDataStore.deleteFavorite(named: "Recette")
        
        XCTAssertTrue(coreDataStore.favoriteRecipes.count == 0)
    }
    
    func testIfAFavoriteRecipeAlreadyExistsThenCoreDataShouldFindIt() {
        coreDataStore.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertTrue(coreDataStore.checkForFavoriteRecipe(named: "Recette"))
    }
    
    func testSearchingForAFavoriteRecipeThatDoesntExistsThenItShouldReturnFalse() {
        coreDataStore.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertFalse(coreDataStore.checkForFavoriteRecipe(named: "Udon"))
    }
}
