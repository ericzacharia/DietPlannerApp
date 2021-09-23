//
//  FoodListViewControllerTests.swift
//  DietPlannerTests
//
//  Created by Eric Zacharia on 4/23/21.
//

import XCTest
@testable import DietPlanner

class FoodListViewControllerTests: XCTestCase {
    var systemUnderTest: FoodListViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.systemUnderTest = navigationController.topViewController as? FoodListViewController
        
        UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first!
            .rootViewController = self.systemUnderTest
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(self.systemUnderTest.view)
    }


    func testTableView_loadsFood() throws {
        //Givens: the enviornment that I've set up for my application
        let mockFoodService = MockFoodService()
        let mockFood = [
        Food(called: "Tofu", caloriesString: "25 calories", calories: 25, protein: 10, carbohydrates: 0, fat: 0, imageUrl: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/the-health-benefits-of-tofu-700-350-1550d79.jpg?quality=90&resize=960,872"),
        Food(called: "Turkey Breast", caloriesString: "100 calories", calories: 100, protein: 15, carbohydrates: 0, fat: 10, imageUrl: "https://www.thespruceeats.com/thmb/FSG6mbqItZpc4675FSdsy7Q_n8k=/4288x2848/filters:fill(auto,1)/roast-turkey-breast-recipe-995372-Hero-5b86f80d46e0fb005028faeb.jpg"),
        Food(called: "Arugula", caloriesString: "10 calories", calories: 10, protein: 1, carbohydrates: 5, fat: 0, imageUrl: "https://assets.rebelmouse.io/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbWFnZSI6Imh0dHBzOi8vYXNzZXRzLnJibC5tcy82NDU3MTk1L29yaWdpbi5qcGciLCJleHBpcmVzX2F0IjoxNjY4MDU0MTIxfQ.AJ1FwuB7JRpbcBlaEghkGubp6NDYkiwRuPPlkL6sgTY/img.jpg?width=1200&coordinates=0%2C25%2C0%2C25&height=600")
        ]
        mockFoodService.mockFood = mockFood
        
        self.systemUnderTest.viewDidLoad()
        self.systemUnderTest.foodService = mockFoodService
        
        XCTAssertEqual(0, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        //When: the action or situation that I want to simulate in my test
        self.systemUnderTest.viewWillAppear(false)
        //Then: the expected and desired behavior where you make sure that you are getting what you would like from your code
        XCTAssertEqual(mockFood.count, self.systemUnderTest.food.count)
        XCTAssertEqual(mockFood.count,self.systemUnderTest.tableView.numberOfRows(inSection: 0))
    }

    class MockFoodService: FoodService {
        var mockFood: [Food]?
        var mockError: Error?
        
        override func getFood(completion: @escaping ([Food]?, Error?) -> ()) {
            completion(mockFood, mockError)
        }
    }

}
