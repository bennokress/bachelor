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
    let factorylayout = FactoryLayout(width: 10, length: 5, entrance: Position(x: 2, y: 0), exit: Position(x: 3, y: 4))
    
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
        guard let testPosition = Position(fromFieldnumber: 25, in: factorylayout) else {
            XCTFail("Given fieldnumber is outside of valid fieldnumbers!")
            return
        }
        XCTAssert(testPosition.x == 5, "x-coordinate for field number 25 should be 5, but is \(testPosition.x)")
        XCTAssert(testPosition.y == 2, "y-coordinate for field number 25 should be 2, but is \(testPosition.y)")
    }
    
    func testPositionInitializationFromInvalidFieldnumberFails() {
        let invalidPosition = Position(fromFieldnumber: 89, in: factorylayout)
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
        // Invalid FactoryLayout for Position(x: 6, y: 4)
        let tooSmallFactoryLayout = FactoryLayout(width: 2, length: 2, entrance: Position(x: 1, y: 0), exit: Position(x: 0, y: 1))
        let invalidFieldnumber = position.getFieldnumber(in: tooSmallFactoryLayout)
        XCTAssert(invalidFieldnumber == nil)
    }
    
    func testDistanceIsCorrectlyCalculated() {
        let pos1 = Position(x: -1, y: -1)
        let pos2 = Position(x: -1, y: +1)
        let pos3 = Position(x: +1, y: -1)
        let pos4 = Position(x: +1, y: +1)
        
        XCTAssert(pos1.getDistance(to: pos1) == 0, "Distance should be 0, but is \(pos1.getDistance(to: pos1))")
        XCTAssert(pos1.getDistance(to: pos2) == 2, "Distance should be 2, but is \(pos1.getDistance(to: pos2))")
        XCTAssert(pos1.getDistance(to: pos3) == 2, "Distance should be 2, but is \(pos1.getDistance(to: pos3))")
        XCTAssert(pos1.getDistance(to: pos4) == 4, "Distance should be 4, but is \(pos1.getDistance(to: pos4))")
    }
    
    func testKnowsIfInsideOrOutsideFactoryLayout() {
        let insidePosition = Position(x: 2, y: 2)
        let outsidePosition = Position(x: 89, y: 89)
        
        XCTAssert(insidePosition.isInFactory(withLayout: factorylayout))
        XCTAssert(!(outsidePosition.isInFactory(withLayout: factorylayout)))
    }
    
}
