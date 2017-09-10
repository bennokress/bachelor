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
    
    // MARK: General Functions
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Tests

    func testTwoProductsWithIdenticalTypeAreEqual() {
        let product1 = Product(type: .testProduct)
        let product2 = Product(type: .testProduct)
        
        XCTAssert(product1 == product2)
    }
    
    func testProductKnowsCorrectRoute() {
        let product = standard.product
        
        XCTAssert(product.neededWorkstations == [.testWorkstation])
    }

}
