//
//  FoodTest.swift
//  DietPlannerTests
//
//  Created by Eric Zacharia on 4/23/21.
//

import XCTest
@testable import DietPlanner

class FoodTest: XCTestCase {

    func testFoodDebugDescription() {
        //Givens: the enviornment that I've set up for my application
        let subjectUnderTest = Food(
            called: "Mango",
            caloriesString: "60 calories",
            calories: 60,
            protein: 1,
            carbohydrates: 15,
            fat: 0,
            imageUrl: "https://cdn.freshfruitportal.com/2019/12/Mango-AdobeStock_178731548-1024x702.jpeg")
        //When: the action or situation that I want to simulate in my test
        let actualValue = subjectUnderTest.debugDescription
        //Then: the expected and desired behavior where you make sure that you are getting what you would like from your code
        let expectedValue = "Food(food: Mango, description: 60 calories)"
        XCTAssertEqual(actualValue, expectedValue)
    }

}
