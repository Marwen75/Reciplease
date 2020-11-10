//
//  HttpClient.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 10/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

class HttpClient {
    
    var session = URLSession.shared
    static let shared = HttpClient()
    private init() {}
    // A generic method to do "GET" request to our apis
    func get<T: Decodable>(url: URLRequest, completionHandler: @escaping (Result<T, ApiError>) -> Void) {
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        completionHandler(.failure(.badRequest))
                        return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseJSON = try decoder.decode(T.self, from: data)
                    completionHandler(.success(responseJSON))
                } catch {
                    completionHandler(.failure(.noData))
                }
            }
        }
        task.resume()
    }
}
