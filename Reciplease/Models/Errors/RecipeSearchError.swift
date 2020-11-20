//
//  RecipeSearchError.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 10/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

enum RecipeSearchError: Error {
    
    case noIngredients
    case noFavorite
    case searchProblem
    case noResults
    
    var errorDescription: String {
        switch self {
        case .noIngredients, .noFavorite, .noResults:
            return "Oups !"
        case .searchProblem:
            return "Sorry !"
        }
    }
    
    var failureReason: String {
        switch self {
        case .noIngredients:
            return "Without ingredients, no recipes !"
        case .noFavorite:
            return "You have no recipe in your favorite list at the time."
        case .searchProblem:
            return "It might look that the app had a search problem."
        case .noResults:
            return "No recipes found, make sure you wrote your ingredients in english, check for misspelling and try again."
        }
    }
}
