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
    var dataStorage: DataStorage!

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        dataStorage = DataStorage(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        dataStorage = nil
        coreDataStack = nil
    }
    
    func testIfAFavoriteRecipeIsAddedThenTheRecipeShouldAppearInCoreData() {
        dataStorage.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertTrue(dataStorage.favoriteRecipes.count == 1)
        XCTAssertTrue(dataStorage.favoriteRecipes[0].name == "Recette")
    }
    
    func testIfAFavoriteIsDeletedThenTheRecipeShouldNotAppearInCoreData() {
        dataStorage.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        dataStorage.deleteFavorite(named: "Recette")
        
        XCTAssertTrue(dataStorage.favoriteRecipes.count == 0)
    }
    
    func testIfAFavoriteRecipeAlreadyExistsThenCoreDataShouldFindIt() {
        dataStorage.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertTrue(dataStorage.checkForFavoriteRecipe(named: "Recette"))
    }
    
    func testSearchingForAFavoriteRecipeThatDoesntExistsThenItShouldReturnFalse() {
        dataStorage.addFavorite(name: "Recette", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20, url: "https://www.gloubi.com", image: "image")
        
        XCTAssertFalse(dataStorage.checkForFavoriteRecipe(named: "Udon"))
    }
}
