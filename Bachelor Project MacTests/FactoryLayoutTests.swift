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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializationGeneratesExpectedFactoryLayoutFieldTypes() {
        
        let wall = FieldType.wall
        let entrance = FieldType.entrance(robots: [])
        let exit = FieldType.exit(robots: [])
        let empty = FieldType.empty
        
        let factoryWidth = 3
        let factoryLength = 3
        let entrancePosition = Position(fromFieldnumber: 1, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
        let exitPosition = Position(fromFieldnumber: 7, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
        
        let layout = FactoryLayout(width: 3, length: 3, entrance: entrancePosition, exit: exitPosition)
        let grid = layout.fields
        
        func count(fieldType type: FieldType, in grid: [Field]) -> Int {
            var count = 0
            for element in grid {
                if element.state == type { count += 1 }
            }
            return count
        }
        
        XCTAssert(count(fieldType: wall, in: grid) == 6, "The fresh grid is supposed to have 6 wall fields, but has \(count(fieldType: wall, in: grid))")
        XCTAssert(count(fieldType: entrance, in: grid) == 1, "The fresh grid is supposed to have 1 entrance, but has \(count(fieldType: entrance, in: grid))")
        XCTAssert(count(fieldType: exit, in: grid) == 1, "The fresh grid is supposed to have 1 exit, but has \(count(fieldType: exit, in: grid))")
        XCTAssert(count(fieldType: empty, in: grid) == 1, "The fresh 3x3 grid is supposed to have 1 empty field in the middle, but has \(count(fieldType: empty, in: grid))")
        
    }
    
    func testAddingWorkstationIsRepresentedInFieldsOfFactoryLayout() {
        var layout = FactoryLayout(width: 3, length: 3, entrance: Position(x: 1, y: 0), exit: Position(x: 1, y: 2))
        
        let testWorkstation = Workstation(type: .testWorkstation, at: Position(fromFieldnumber: 4, in: layout)!)
        layout.addWorkstation(testWorkstation)
        let grid = layout.fields
        
        var returnedFieldTypes: [FieldType] = []
        for field in grid {
            returnedFieldTypes.append(field.state)
        }
        
        dump(returnedFieldTypes)
        
        let expectedFieldTypes: [FieldType] = [.wall, .wall, .wall, .wall, .workstation(object: testWorkstation), .wall, .wall, .wall, .wall]
        
        XCTAssert(returnedFieldTypes[4] == expectedFieldTypes[4], "We expected a workstation at fieldnumber 4 of the factory layout")
    }
    
}
