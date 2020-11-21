//
//  RecipeService.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
import Alamofire
import Foundation

// The recipe service will perform our requests to the edamam API 
class RecipeService {
    
    var session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func getRecipes(ingredients: [String], completionHandler: @escaping (Result<RecipeSearchResult, ApiError>) -> Void) {
        let apiLogs = ApiKey()
        guard let usableUrl = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(apiLogs.id)&app_key=\(apiLogs.key)&from=0&to=100") else {
            return
        }
        session.request(url: usableUrl) { data ,urlResponse, error in
            guard let data = data else {
                print("databug1")
                completionHandler(.failure(.noData))
                return
            }
            guard urlResponse?.statusCode == 200 else {
                print("badrequest bug")
                completionHandler(.failure(.badRequest))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseJSON = try decoder.decode(RecipeSearchResult.self, from: data)
                completionHandler(.success(responseJSON))
            } catch {
                print("Problem JSON")
                completionHandler(.failure(.noData))
            }
        }
    }
}
