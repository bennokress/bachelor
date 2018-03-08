//
//  ProductTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class ProductTests: XCTestCase {
    
    let standard = StandardImplementation()

    func testTwoProductsWithIdenticalTypeAreEqual() {
        
        // MARK: 🌦 Given
        let product1 = Product(type: .testProduct)
        let product2 = Product(type: .testProduct)
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(product1 == product2)
        
    }
    
    func testProductKnowsCorrectRoute() {
        
        // MARK: 🌦 Given
        let product = standard.product
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(product.neededWorkstations == [.testWorkstation])
        
    }

}
