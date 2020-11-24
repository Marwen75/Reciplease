//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Marwen Haouacine on 15/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
@testable import Reciplease
import XCTest
import Alamofire

// Tests for the recipe service
class RecipeServiceTestCase: XCTestCase {

    var error: ApiError!
    
    
    func testGetRecipesShouldPostFailedCompletionHandlerIfThereIsNoDataAtAll() {
        let session = AlamoSessionFake(response: FakeAlamoResponse(error: nil, data: nil, response: nil))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with no data.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostFailedCompletionHandlerIfABadRequestIsMade() {
        let session = AlamoSessionFake(response: FakeAlamoResponse(error: error, data: FakeResponseData.edamamCorrectData, response: FakeResponseData.responseKO))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with bad response.")
                return
            }
            XCTAssertNotNil(error)
            XCTAssertEqual(error, ApiError.badRequest)
            XCTAssertTrue(error.errorDescription == "Oups !")
            XCTAssertTrue(error.failureReason == "The request has failed.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostFailedCompletionHandlerIfDatasAreIncorrect() {
        let session = AlamoSessionFake(response: FakeAlamoResponse(error: error, data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test must fail with incorrect data.")
                return
            }
            XCTAssertNotNil(error)
            XCTAssertEqual(error, ApiError.noData)
            XCTAssertTrue(error.errorDescription == "Oups !")
            XCTAssertTrue(error.failureReason == "These data can't be retrieved at the moment.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostSuccessCompletionHandlerIfNoErrorGoodDataAndGoodResponse() {
        let session = AlamoSessionFake(response: FakeAlamoResponse(error: error, data: FakeResponseData.edamamCorrectData, response: FakeResponseData.responseOK))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .success(let result) = result else {
                XCTFail("Test must succeed.")
                return
            }
            XCTAssertNotNil(result)
            XCTAssertTrue(result.first?.label == "Chicken Vesuvio")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testGetRecipesShouldPostSuccessCompletionHandlerWithTheRealAlamoClient() {
        let requestService = RecipeService(session: AlamoClient() as SessionProtocol)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .success(let result) = result else {
                XCTFail("test must succeed.")
                return
            }
            XCTAssertNotNil(result)
            XCTAssertTrue(result.first?.label == "Chicken Vesuvio")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 7)
    }
}
