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
        let layout = FactoryLayout(width: 3, length: 3)
        let grid = layout.fields
        
        var returnedFieldTypes: [FieldType] = []
        for field in grid {
            returnedFieldTypes.append(field.state)
        }
        
        let expectedFieldTypes: [FieldType] = [.wall, .wall, .wall, .wall, .empty, .wall, .wall, .wall, .wall]
        
        XCTAssert(returnedFieldTypes == expectedFieldTypes, "We expected an empty field surrounded only by walls in an empty 3x3 FactoryLayout")
    }
    
}
