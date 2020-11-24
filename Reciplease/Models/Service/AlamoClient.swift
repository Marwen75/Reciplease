//
//  AlamoClient.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import Alamofire

// The client using alamofire to send request to the api 

class AlamoClient: SessionProtocol {
    
    func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        AF.request(url).responseJSON { responseData in
            completionHandler(responseData.data, responseData.response, responseData.error)
        }
    }
}
