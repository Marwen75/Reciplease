//
//  RecipeService.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
import Alamofire
import Foundation

class RecipeService {
    
    func getRecipes(ingredients: [String], completionHandler: @escaping (Result<RecipeSearchResult, ApiError>) -> Void) {
        let apiLogs = ApiKey()
        guard let usableUrl = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(apiLogs.id)&app_key=\(apiLogs.key)") else {
            return
        }
        AF.request(usableUrl).responseJSON { responseData in
            guard let data = responseData.data else {
                print("databug1")
                completionHandler(.failure(.noData))
                return
            }
            guard responseData.response?.statusCode == 200 else {
                print("badrequest bug")
                completionHandler(.failure(.badRequest))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseJSON = try decoder.decode(RecipeSearchResult.self, from: data)
                completionHandler(.success(responseJSON))
            } catch {
                print("jsonpabon")
                completionHandler(.failure(.noData))
            }
        }
    }
}
