//
//  FoodServiceTests.swift
//  DietPlannerTests
//
//  Created by Eric Zacharia on 4/23/21.
//

import XCTest
@testable import DietPlanner
class FoodServiceTests: XCTestCase {
    var systemUnderTest: FoodService!

    override func setUpWithError() throws {
        self.systemUnderTest = FoodService()
    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil
    }

    func testAPI_returnsSuccessfulResult() throws {
        //Givens: the enviornment that I've set up for my application
        var food: [Food]!
        var error: Error?
        
        let promise = expectation(description: "Completion handler is invoked")
        //When: the action or situation that I want to simulate in my test
        self.systemUnderTest.getFood(completion: {data, shouldntHappen in
            food = data
            error = shouldntHappen
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        //Then: the expected and desired behavior where you make sure that you are getting what you would like from your code
        XCTAssertNotNil(food)
        XCTAssertNil(error)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
