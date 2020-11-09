//
//  ApiError.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

enum ApiError: Error {
    
    case noData
    case badRequest
    case noInternet
    
    var errorDescription: String {
        return "Oups !"
    }
    var failureReason: String {
        switch self {
        case .noData:
            return "Ces données ne peuvent pas être fournies pour le moment."
        case .badRequest:
            return "La requète réseau a échouée"
        case .noInternet:
            return "Le service est indisponible! Vous ne semblez pas connecté à internet"
        }
    }
}
