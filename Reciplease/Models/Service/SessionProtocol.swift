//
//  SessionProtocol.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import Alamofire

public protocol SessionProtocol {
    
     func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void)
    
}
