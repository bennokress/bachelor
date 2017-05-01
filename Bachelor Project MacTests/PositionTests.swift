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
    
    // MARK: Standard implementations to start with in each test, if needed
    
    var standardPosition1: Position {
        return Position(x: 3, y: 2)
    }
    
    var standardPosition2: Position {
        return Position(x: 6, y: 2)
    }
    
    var standardField1: Field {
        return Field(at: standardPosition1)
    }
    
    var standardField2: Field {
        return Field(at: standardPosition2)
    }
    
    var standardEmptyFactoryLayout: FactoryLayout {
        let entrance = Position(x: 2, y: 0)
        let exit = Position(x: 7, y: 4)
        return FactoryLayout(width: 10, length: 5, entrance: entrance, exit: exit)
    }
    
    var standardFactoryLayout: FactoryLayout {
        var factoryLayout = standardEmptyFactoryLayout
        factoryLayout.addWorkstation(standardWorkstation)
        return factoryLayout
    }
    
    var standardProduct: Product {
        return Product(type: .testProduct)
    }
    
    var standardWorkstation: Workstation {
        return Workstation(type: .testWorkstation, at: standardPosition2)
    }
    
    var standardRobot: Robot {
        return Robot(product: standardProduct, in: standardFactoryLayout)
    }
    
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
    
    func testPositionDefaultInitialization() {
        XCTAssert(standardPosition1.x == 3)
        XCTAssert(standardPosition1.y == 2)
        XCTAssert(standardPosition2.x == 6)
        XCTAssert(standardPosition2.y == 2)
    }
    
    func testEmptyFieldsAreIdentifiedCorrectly() {
        let factoryLayout = standardFactoryLayout
        
        var emptyFieldCount = 0
        for field in factoryLayout.fields {
            if field.isEmpty { emptyFieldCount += 1 }
        }
        
        XCTAssert(emptyFieldCount == 23, "50 total fields -  24 walls - 1 entrance - 1 exit - 1 workstation = 23 empty fields -> \(emptyFieldCount) were counted!")
    }
    
    func testPositionInitializationFromFieldnumber() {
        guard let testPosition = Position(fromFieldnumber: 25, in: standardFactoryLayout) else {
            XCTFail("Given fieldnumber is outside of valid fieldnumbers!")
            return
        }
        XCTAssert(testPosition.x == 5, "x-coordinate for field number 25 should be 5, but is \(testPosition.x)")
        XCTAssert(testPosition.y == 2, "y-coordinate for field number 25 should be 2, but is \(testPosition.y)")
    }
    
    func testPositionInitializationFromInvalidFieldnumberFails() {
        let invalidPosition = Position(fromFieldnumber: 89, in: standardFactoryLayout)
        XCTAssert(invalidPosition == nil)
    }
    
    func testPositionConvertionToFieldnumber() {
        guard let fieldnumber = standardPosition1.getFieldnumber(in: standardFactoryLayout) else {
            XCTFail("Fieldnumber was not computed!")
            return
        }
        XCTAssert(fieldnumber == 23)
    }
    
    func testPositionFieldnumberConversionInInvalidFactoryLayoutFails() {
        // Invalid FactoryLayout for Position(x: 6, y: 4)
        let tooSmallFactoryLayout = FactoryLayout(width: 2, length: 2, entrance: Position(x: 1, y: 0), exit: Position(x: 0, y: 1))
        let invalidFieldnumber = standardPosition1.getFieldnumber(in: tooSmallFactoryLayout)
        XCTAssert(invalidFieldnumber == nil)
    }
    
    func testDistanceIsCorrectlyCalculated() {
        let pos1 = Position(x: -1, y: -1)
        let pos2 = Position(x: -1, y: +1)
        let pos3 = Position(x: +1, y: -1)
        let pos4 = Position(x: +1, y: +1)
        
        XCTAssert(pos1.distance(to: pos1) == 0, "Distance should be 0, but is \(pos1.distance(to: pos1))")
        XCTAssert(pos1.distance(to: pos2) == 2, "Distance should be 2, but is \(pos1.distance(to: pos2))")
        XCTAssert(pos1.distance(to: pos3) == 2, "Distance should be 2, but is \(pos1.distance(to: pos3))")
        XCTAssert(pos1.distance(to: pos4) == 4, "Distance should be 4, but is \(pos1.distance(to: pos4))")
    }
    
    func testKnowsIfInsideOrOutsideFactoryLayout() {
        let insidePosition = Position(x: 2, y: 2)
        let outsidePosition = Position(x: 89, y: 89)
        
        XCTAssert(insidePosition.isInFactory(withLayout: standardFactoryLayout))
        XCTAssert(!(outsidePosition.isInFactory(withLayout: standardFactoryLayout)))
    }
    
    func testRandomEmptyFieldIsIndeedEmpty() {
        let factoryLayout = standardFactoryLayout
        let randomEmptyFieldPosition = Position.ofRandomEmptyField(in: factoryLayout)
        
        guard let fieldnumber = randomEmptyFieldPosition.getFieldnumber(in: factoryLayout) else {
            XCTFail("Random position was outside of factory!")
            return
        }
        
        XCTAssert(factoryLayout.fields[fieldnumber].isEmpty, "Random position was not empty!")
    }
    
}
