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
    case wrongSpelling
    
    var errorDescription: String {
        switch self {
        case .noIngredients, .noFavorite, .wrongSpelling:
            return "Oups !"
        case .searchProblem:
            return "Désolé !"
        }
    }
    
    var failureReason: String {
        switch self {
        case .noIngredients:
            return "Sans ingrédients, pas de recettes !"
        case .noFavorite:
            return "Vous n'avez aucune recette dans vos favoris"
        case .searchProblem:
            return "Un problème de données et survenue."
        case .wrongSpelling:
            return "Veuillez entrer votre ingrédient en Anglais, sans ponctuations et sans espaces."
        }
    }
}
