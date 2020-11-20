//
//  AlamoSessionFake.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 16/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import XCTest
@testable import Reciplease
import Alamofire

class AlamoSessionFake: SessionProtocol {
    
    let response: FakeAlamoResponse
    
    init(response: FakeAlamoResponse) {
        self.response = response
    }
    
    func request(url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        completionHandler(response.data, response.response, response.error)
    }
}

struct FakeAlamoResponse {
    var error: Error?
    var data: Data?
    var response: HTTPURLResponse?
}
