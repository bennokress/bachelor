//
//  FactoryLayoutTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 28.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class FactoryLayoutTests: XCTestCase {
    
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
    
    func testInitializationGeneratesExpectedFactoryLayoutFieldTypes() {
        
        let wall = FieldType.wall
        let entrance = FieldType.entrance(robots: [])
        let exit = FieldType.exit(robots: [])
        let empty = FieldType.empty
        
        let layout = standard.emptyFactoryLayout
        let grid = layout.fields
        
        func count(fieldType type: FieldType, in grid: [Field]) -> Int {
            var count = 0
            for element in grid {
                if element.state == type { count += 1 }
            }
            return count
        }
        
        XCTAssert(count(fieldType: wall, in: grid) == 24, "The fresh grid is supposed to have 24 wall fields, but has \(count(fieldType: wall, in: grid))")
        XCTAssert(count(fieldType: entrance, in: grid) == 1, "The fresh grid is supposed to have 1 entrance, but has \(count(fieldType: entrance, in: grid))")
        XCTAssert(count(fieldType: exit, in: grid) == 1, "The fresh grid is supposed to have 1 exit, but has \(count(fieldType: exit, in: grid))")
        XCTAssert(count(fieldType: empty, in: grid) == 24, "The fresh 10x5 grid is supposed to have 24 empty fields, but has \(count(fieldType: empty, in: grid))")
        
    }
    
    func testAddingWorkstationIsRepresentedInFieldsOfFactoryLayout() {
        
        let expectedWorkstation: FieldType = .workstation(object: standard.workstation)
        let factoryLayout = standard.factoryLayout
        
        XCTAssert(factoryLayout.fields[26].state == expectedWorkstation, "We expected a workstation at fieldnumber 26 of the factory layout")
    }
    
}
