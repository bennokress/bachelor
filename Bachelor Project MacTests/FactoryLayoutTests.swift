//
//  FactoryLayoutTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 28.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
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
    
    func testInitializationGeneratesExpectedFactoryLayoutFieldStates() {
        
        let wall = FieldState.wall
        let entrance = FieldState.entrance(robots: [])
        let exit = FieldState.exit(robots: [])
        let empty = FieldState.empty
        
        let layout = standard.emptyFactoryLayout
        let grid = layout.fields
        
        func count(fieldState state: FieldState, in grid: [Field]) -> Int {
            var count = 0
            for element in grid {
                if element.state == state { count += 1 }
            }
            return count
        }
        
        XCTAssert(count(fieldState: wall, in: grid) == 24, "The fresh grid is supposed to have 24 wall fields, but has \(count(fieldState: wall, in: grid))")
        XCTAssert(count(fieldState: entrance, in: grid) == 1, "The fresh grid is supposed to have 1 entrance, but has \(count(fieldState: entrance, in: grid))")
        XCTAssert(count(fieldState: exit, in: grid) == 1, "The fresh grid is supposed to have 1 exit, but has \(count(fieldState: exit, in: grid))")
        XCTAssert(count(fieldState: empty, in: grid) == 24, "The fresh 10x5 grid is supposed to have 24 empty fields, but has \(count(fieldState: empty, in: grid))")
        
    }
    
    func testAddingWorkstationIsRepresentedInFieldsOfFactoryLayout() {
        
        let expectedWorkstation: FieldState = .workstation(object: standard.workstation)
        let factoryLayout = standard.factoryLayout
        
        XCTAssert(factoryLayout.fields[26].state == expectedWorkstation, "We expected a workstation at fieldnumber 26 of the factory layout")
    }
    
}
