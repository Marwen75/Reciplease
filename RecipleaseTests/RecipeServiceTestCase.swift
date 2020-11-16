//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
@testable import Reciplease
import XCTest

class RecipeServiceTestCase: XCTestCase {

    
    func testTest() {
        let session = AlamoSessionFake(response: FakeAlamoResponse(urlResponse: nil, data: nil))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test request method with no data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
