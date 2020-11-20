//
//  SessionProtocol.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import Alamofire

// The session protocol to not depend only on Alamofire and also to help  with the test

protocol SessionProtocol {
    
     func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}
