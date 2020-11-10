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
    case eraseIngredients
    case wrongSpelling
    
    var errorDescription: String {
        switch self {
        case .noIngredients, .noFavorite, .wrongSpelling:
            return "Oups !"
        case .eraseIngredients:
            return "Attention"
        }
    }
    
    var failureReason: String {
        switch self {
        case .noIngredients:
            return "Sans ingrédients, pas de recettes !"
        case .noFavorite:
            return "Vous n'avez aucune recette dans vos favoris"
        case .eraseIngredients:
            return "Ceci effacera tous les ingrédients de votre liste"
        case .wrongSpelling:
            return "Veuillez entrer votre ingrédient en toutes lettres et sans ponctuations."
        }
    }
}
