//
//  FieldTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 28.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class FieldTests: XCTestCase {
    
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
    
    var standardProduct: Product {
        return Product(type: .testProduct)
    }
    
    var standardWorkstation: Workstation {
        return Workstation(type: .testWorkstation, at: standardPosition2)
    }
    
    var standardRobot: Robot {
        return Robot(product: standardProduct, in: standardEmptyFactoryLayout)
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializationWithPositionOnlyGeneratesAnEmptyField() {
        XCTAssert(standardField1.isEmpty)
    }
    
    func testAddsWorkstationToEmptyField() {
        let testWorkstation = standardWorkstation
        
        var testField = standardField2
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.workstation == testWorkstation, "The field should have a workstation. It also has the wrong type if this test fails!")
    }
    
    func testAddsAndRemovesRobot() {
        var testRobot = standardRobot
        
        var testField = standardField1
        testField.addRobot(&testRobot)
        XCTAssert(testField.robot == testRobot, "The field should have a robot. It also has the wrong type if this test fails!")
        
        testField.removeRobot(testRobot)
        XCTAssert(testField.isEmpty)
    }
    
    func testFieldTypeCapacity() {
        var testField = standardField1
        
        XCTAssert(testField.hasRemainingCapacity, "An empty field should always have remaining capacity!")
        
        testField.state = .entrance(robots: [])
        XCTAssert(testField.hasRemainingCapacity, "The entrance should always have remaining capacity!")
        
        testField.state = .exit(robots: [])
        XCTAssert(testField.hasRemainingCapacity, "The exit should always have remaining capacity!")
        
        testField.state = .wall
        XCTAssert(!(testField.hasRemainingCapacity), "A wall should never have remaining capacity!")
        
        var testRobot = standardRobot
        
        testField.clear()
        testField.addRobot(&testRobot)
        XCTAssert(!(testField.hasRemainingCapacity), "A field occupied by a robot should never have remaining capacity!")
        
        var testWorkstation = standardWorkstation
        testWorkstation.state = .idle
        
        testField.removeRobot(testRobot)
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.hasRemainingCapacity, "An idle workstation should always have remaining capacity!")
        
        testField.addRobot(&testRobot)
        XCTAssert(!(testField.hasRemainingCapacity), "A busy workstation should never have remaining capacity!")
    }
    
    func testKnowsWorkstationIfApplicable() {
        let testWorkstation = standardWorkstation
        
        var testField = standardField1
        testField.addWorkstation(testWorkstation)
        
        XCTAssert(testField.workstation == testWorkstation)
        
        testField.clear()
        XCTAssert(testField.workstation == nil)
    }
    
    func testKnowsRobotIfApplicable() {
        var testRobot = standardRobot
        let testWorkstation = standardWorkstation
        
        var testField = standardField1
        testField.addRobot(&testRobot)
        
        XCTAssert(testField.robot == testRobot)
        
        testField.clear()
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.robot == nil)
        
        testField.addRobot(&testRobot)
        XCTAssert((testField.workstation == testWorkstation) && (testField.robot == testRobot), "A field with a busy workstation should know both the robot and the workstation!")
    }

}
