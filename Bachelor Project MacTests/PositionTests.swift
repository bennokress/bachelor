//
//  PositionTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class PositionTests: XCTestCase {
    
    let position = Position(x: 6, y: 4)
    let factorylayout = FactoryLayout(width: 10, height: 10)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPositionDefaultInitialization() {
        XCTAssert(position.x == 6)
        XCTAssert(position.y == 4)
    }
    
    func testPositionInitializationFromFieldnumber() {
        guard let testPosition = Position(fromFieldnumber: 89, in: factorylayout) else {
            XCTFail("Given fieldnumber is outside of valid fieldnumbers!")
            return
        }
        XCTAssert(testPosition.x == 9)
        XCTAssert(testPosition.y == 8)
    }
    
    func testPositionInitializationFromInvalidFieldnumberFails() {
        let invalidPosition = Position(fromFieldnumber: 120, in: factorylayout)
        XCTAssert(invalidPosition == nil)
    }
    
    func testPositionConvertionToFieldnumber() {
        guard let fieldnumber = position.getFieldnumber(in: factorylayout) else {
            XCTFail("Fieldnumber was not computed!")
            return
        }
        XCTAssert(fieldnumber == 46)
    }
    
    func testPositionFieldnumberConversionInInvalidFactoryLayoutFails() {
        let tooSmallFactoryLayout = FactoryLayout(width: 1, height: 1) // Invalid FactoryLayout for Position(x: 6, y: 4)
        let invalidFieldnumber = position.getFieldnumber(in: tooSmallFactoryLayout)
        XCTAssert(invalidFieldnumber == nil)
    }
    
}
