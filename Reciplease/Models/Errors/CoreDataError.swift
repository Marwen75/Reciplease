//
//  CoreDataError.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 14/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

enum CoreDataError: Error {
    
    case saveProblem
    
    var errorDescription: String {
        return "Oups !"
    }
    var failureReason: String {
        switch self {
        case .saveProblem:
            return "Ces données ne peuvent pas être sauvegardées pour le moment"
        }
    }
}
