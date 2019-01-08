//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Daksh Gargs on 19/12/18.
//  Copyright © 2018 Daksh Gargs. All rights reserved.
//

import XCTest

/*Gives test access to the internal elements of the app's code*/
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    //MARK: Meal Class Tests
    //  Confrim that the Meal initializer retuns a Meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //  Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //  Confirm that the Meal initializer returns nil when passed a negative rating or an empty name
    func testMealInitializationFails() {
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //  Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        //  Empty String
        let emptyStringName = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringName)
    }
}
