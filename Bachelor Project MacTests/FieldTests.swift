//
//  FieldTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 28.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class FieldTests: XCTestCase {
    
    let standard = StandardImplementation()
    
    func testInitializationWithPositionOnlyGeneratesAnEmptyField() {
        
        // MARK: 🌦 Given
        // Standard implementation with no modification
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(standard.field1.isEmpty)
        
    }
    
    func testAddsWorkstationToEmptyField() {
        
        // MARK: 🌦 Given
        let testWorkstation = standard.workstation
        var testField = standard.field2
        
        // MARK: 🌬 When
        testField.addWorkstation(testWorkstation)
        
        // MARK: ☀️ Then
        XCTAssert(testField.workstation == testWorkstation, "The field should have a workstation. It also has the wrong state if this test fails!")
        
    }
    
    func testAddsAndRemovesRobot() {
        
        // MARK: 🌦 Given
        let testRobot = standard.robot
        var testField = standard.field1
        
        // MARK: 🌬 When
        testField.addRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert(testField.robot == testRobot, "The field should have a robot. It also has the wrong state if this test fails!")
        
        // MARK: 🌬 When
        testField.removeRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert(testField.isEmpty)
        
    }
    
    func testFieldStateCapacity() {
        
        // MARK: 🌦 Given
        var testField = standard.field1
        let testRobot = standard.robot
        var testWorkstation = standard.workstation
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(testField.hasRemainingCapacity, "An empty field should always have remaining capacity!")
        
        // MARK: 🌬 When
        testField.state = .entrance(robots: [])
        
        // MARK: ☀️ Then
        XCTAssert(testField.hasRemainingCapacity, "The entrance should always have remaining capacity!")
        
        // MARK: 🌬 When
        testField.state = .exit(robots: [])
        
        // MARK: ☀️ Then
        XCTAssert(testField.hasRemainingCapacity, "The exit should always have remaining capacity!")
        
        // MARK: 🌬 When
        testField.state = .wall
        
        // MARK: ☀️ Then
        XCTAssert(!(testField.hasRemainingCapacity), "A wall should never have remaining capacity!")
        
        // MARK: 🌬 When
        testField.clear()
        testField.addRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert(!(testField.hasRemainingCapacity), "A field occupied by a robot should never have remaining capacity!")
        
        // MARK: 🌬 When
        testWorkstation.state = .idle
        testField.removeRobot(testRobot)
        testField.addWorkstation(testWorkstation)
        
        // MARK: ☀️ Then
        XCTAssert(testField.hasRemainingCapacity, "An idle workstation should always have remaining capacity!")
        
        // MARK: 🌬 When
        testField.addRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert(!(testField.hasRemainingCapacity), "A busy workstation should never have remaining capacity!")
        
    }
    
    func testKnowsWorkstationIfApplicable() {
        
        // MARK: 🌦 Given
        let testWorkstation = standard.workstation
        var testField = standard.field1
        
        // MARK: 🌬 When
        testField.addWorkstation(testWorkstation)
        
        // MARK: ☀️ Then
        XCTAssert(testField.workstation == testWorkstation)
        
        // MARK: 🌬 When
        testField.clear()
        
        // MARK: ☀️ Then
        XCTAssert(testField.workstation == nil)
        
    }
    
    func testKnowsRobotIfApplicable() {
        
        // MARK: 🌦 Given
        let testRobot = standard.robot
        let testWorkstation = standard.workstation
        var testField = standard.field1
        
        // MARK: 🌬 When
        testField.addRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert(testField.robot == testRobot)
        
        // MARK: 🌬 When
        testField.clear()
        testField.addWorkstation(testWorkstation)
        
        // MARK: ☀️ Then
        XCTAssert(testField.robot == nil)
        
        // MARK: 🌬 When
        testField.addRobot(testRobot)
        
        // MARK: ☀️ Then
        XCTAssert((testField.workstation == testWorkstation) && (testField.robot == testRobot), "A field with a busy workstation should know both the robot and the workstation!")
        
    }

}
