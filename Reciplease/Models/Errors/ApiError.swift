//
//  ApiError.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
// An enum for the error that can occur during api requests
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
            return "These data can't be retrieved at the moment."
        case .badRequest:
            return "The request has failed."
        case .noInternet:
            return "Service unavailable at the moment, it seems your are not connected to the internet."
        }
    }
}
