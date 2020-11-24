//
//  RecipeService.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
import Foundation

// The recipe service will perform our requests to the edamam API 
class RecipeService {
    
    var session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func getRecipes(ingredients: [String], completionHandler: @escaping (Result<[Recipes], ApiError>) -> Void) {
        guard let usableUrl = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiKey.id)&app_key=\(ApiKey.key)&from=0&to=100") else {
            return
        }
        session.request(url: usableUrl) { data ,urlResponse, error in
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            guard urlResponse?.statusCode == 200 else {
                completionHandler(.failure(.badRequest))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseJSON = try decoder.decode(RecipeSearchResult.self, from: data)
                let recipes = responseJSON.hits.map { $0.recipe }
                completionHandler(.success(recipes))
            } catch {
                completionHandler(.failure(.noData))
            }
        }
    }
}
