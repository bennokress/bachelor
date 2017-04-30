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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializationWithPositionOnlyGeneratesAnEmptyField() {
        let position = Position(x: 0, y: 0)
        let field = Field(at: position)
        
        XCTAssert(field.isEmpty)
    }
    
    func testFieldTypeCapacity() {
        let position = Position(x: 0, y: 0)
        var field = Field(at: position)
        
        XCTAssert(field.hasRemainingCapacity, "An empty field should always have remaining capacity!")
        
        field.state = .entrance(robots: [])
        XCTAssert(field.hasRemainingCapacity, "The entrance should always have remaining capacity!")
        
        field.state = .exit(robots: [])
        XCTAssert(field.hasRemainingCapacity, "The exit should always have remaining capacity!")
        
        field.state = .wall
        XCTAssert(!(field.hasRemainingCapacity), "A wall should never have remaining capacity!")
        
        var workstation = Workstation(type: .testWorkstation, at: position)
        workstation.state = .idle
        field.state = .workstation(object: workstation)
        XCTAssert(field.hasRemainingCapacity, "An idle workstation should always have remaining capacity!")
        
        workstation.state = .busy
        field.state = .workstation(object: workstation)
        XCTAssert(!(field.hasRemainingCapacity), "A busy workstation should never have remaining capacity!")
        
        let robot = Robot(product: Product(type: .testProduct), in: FactoryLayout())
        field.state = .robot(object: robot)
        XCTAssert(!(field.hasRemainingCapacity), "A field occupied by a robot should never have remaining capacity!")
    }

}
