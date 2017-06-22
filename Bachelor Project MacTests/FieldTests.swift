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
    
    func testInitializationWithPositionOnlyGeneratesAnEmptyField() {
        XCTAssert(standard.field1.isEmpty)
    }
    
    func testAddsWorkstationToEmptyField() {
        let testWorkstation = standard.workstation
        
        var testField = standard.field2
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.workstation == testWorkstation, "The field should have a workstation. It also has the wrong type if this test fails!")
    }
    
    func testAddsAndRemovesRobot() {
        let testRobot = standard.robot
        
        var testField = standard.field1
        testField.addRobot(testRobot)
        XCTAssert(testField.robot == testRobot, "The field should have a robot. It also has the wrong type if this test fails!")
        
        testField.removeRobot(testRobot)
        XCTAssert(testField.isEmpty)
    }
    
    func testFieldTypeCapacity() {
        var testField = standard.field1
        
        XCTAssert(testField.hasRemainingCapacity, "An empty field should always have remaining capacity!")
        
        testField.state = .entrance(robots: [])
        XCTAssert(testField.hasRemainingCapacity, "The entrance should always have remaining capacity!")
        
        testField.state = .exit(robots: [])
        XCTAssert(testField.hasRemainingCapacity, "The exit should always have remaining capacity!")
        
        testField.state = .wall
        XCTAssert(!(testField.hasRemainingCapacity), "A wall should never have remaining capacity!")
        
        let testRobot = standard.robot
        
        testField.clear()
        testField.addRobot(testRobot)
        XCTAssert(!(testField.hasRemainingCapacity), "A field occupied by a robot should never have remaining capacity!")
        
        var testWorkstation = standard.workstation
        testWorkstation.state = .idle
        
        testField.removeRobot(testRobot)
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.hasRemainingCapacity, "An idle workstation should always have remaining capacity!")
        
        testField.addRobot(testRobot)
        XCTAssert(!(testField.hasRemainingCapacity), "A busy workstation should never have remaining capacity!")
    }
    
    func testKnowsWorkstationIfApplicable() {
        let testWorkstation = standard.workstation
        
        var testField = standard.field1
        testField.addWorkstation(testWorkstation)
        
        XCTAssert(testField.workstation == testWorkstation)
        
        testField.clear()
        XCTAssert(testField.workstation == nil)
    }
    
    func testKnowsRobotIfApplicable() {
        let testRobot = standard.robot
        let testWorkstation = standard.workstation
        
        var testField = standard.field1
        testField.addRobot(testRobot)
        
        XCTAssert(testField.robot == testRobot)
        
        testField.clear()
        testField.addWorkstation(testWorkstation)
        XCTAssert(testField.robot == nil)
        
        testField.addRobot(testRobot)
        XCTAssert((testField.workstation == testWorkstation) && (testField.robot == testRobot), "A field with a busy workstation should know both the robot and the workstation!")
    }

}
