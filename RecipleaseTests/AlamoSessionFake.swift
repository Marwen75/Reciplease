//
//  AlamoSessionFake.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 16/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import XCTest
import Reciplease
import Alamofire

class AlamoSessionFake: SessionProtocol {
    
    let response: FakeAlamoResponse
    
    init(response: FakeAlamoResponse) {
        self.response = response
    }
    
    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let result = AF
    }
}

struct FakeAlamoResponse {
    var urlResponse: HTTPURLResponse?
    var data: Data?
    var response: HTTPURLResponse?
}
