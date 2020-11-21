//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 16/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation

class FakeResponseData {
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.hackingwithswift.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.hackingwithswift.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    static var edamamCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "edamam", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    static let incorrectData = "fsdfqefsf".data(using: .utf8)
}
