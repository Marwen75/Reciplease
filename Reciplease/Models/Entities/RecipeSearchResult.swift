//
//  Recipe.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

// Decodable objects to parse the JSON data received by the API

struct RecipeSearchResult: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipes
}

struct Recipes: Decodable {
    let label: String
    let image: String
    let url: String
    let yield: Float?
    let ingredientLines: [String]
    let totalTime: Float?
}
