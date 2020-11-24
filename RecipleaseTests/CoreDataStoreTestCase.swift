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

// Tests for coredata
class CoreDataStoreTestCase: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var favoriteRecipeStorage: FavoriteRecipeStorage!
    var recipe: RecipeModel!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        favoriteRecipeStorage = FavoriteRecipeStorage(coreDataStack: coreDataStack)
        recipe = RecipeModel(name: "Recette", image: "image", url: "https://www.hackingwithswit.com", ingredients: ["Bread", "Garlic", "Rice"], yield: 2, time: 20)
        expectation = XCTestExpectation(description: "Wait for queue change.")
    }
    
    override func tearDown() {
        super.tearDown()
        favoriteRecipeStorage = nil
        coreDataStack = nil
        recipe = nil
        expectation = nil
    }
    
    func testIfAFavoriteRecipeIsAddedThenTheRecipeShouldAppearInCoreData() {
        favoriteRecipeStorage.addFavorite(recipe: recipe) {
            XCTAssertTrue(self.favoriteRecipeStorage.favoriteRecipes.count == 1)
            XCTAssertTrue(self.favoriteRecipeStorage.favoriteRecipes[0].name == "\(self.recipe.name)")
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testIfAFavoriteIsDeletedThenTheRecipeShouldNotAppearInCoreData() {
        favoriteRecipeStorage.addFavorite(recipe: recipe) {
            XCTAssertTrue(self.favoriteRecipeStorage.favoriteRecipes[0].name == "\(self.recipe.name)")
        }
        favoriteRecipeStorage.deleteFavorite(named: "\(recipe.name)") {
            XCTAssertTrue(self.favoriteRecipeStorage.favoriteRecipes.count == 0)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testIfAFavoriteRecipeAlreadyExistsThenCoreDataShouldFindIt() {
        favoriteRecipeStorage.addFavorite(recipe: recipe) {
            XCTAssertTrue(self.favoriteRecipeStorage.checkForFavoriteRecipe(named: "\(self.recipe.name)"))
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSearchingForAFavoriteRecipeThatDoesntExistsThenItShouldReturnFalse() {
        favoriteRecipeStorage.addFavorite(recipe: recipe) {
            XCTAssertFalse(self.favoriteRecipeStorage.checkForFavoriteRecipe(named: "Udon"))
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
