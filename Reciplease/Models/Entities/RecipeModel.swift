//
//  EasyRecipeDisplay.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 14/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

// An object to manipulate easily a recipe throughout the code

struct RecipeModel {
    let name: String
    let image: String
    let url: String
    let ingredients: [String]
    let yield: Int
    let time: Int
    var isFavorite = false
}
