//
//  WorkstationTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class WorkstationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTwoWorkstationsWithIdenticalTypeAndPositionAreEqual() {
        let workstation1 = Workstation(type: .testWorkstation, at: Position(x: 1, y: 2))
        let workstation2 = Workstation(type: .testWorkstation, at: Position(x: 1, y: 2))
        
        XCTAssert(workstation1 == workstation2)
        
        let workstation3 = Workstation(type: .wsA, at: Position(x: 1, y: 2))
        let workstation4 = Workstation(type: .testWorkstation, at: Position(x: 2, y: 2))
        
        XCTAssert(workstation1 != workstation3)
        XCTAssert(workstation1 != workstation4)
    }
    
    func testWorkstationKnowsIfIdle() {
        var workstation = Workstation(type: .testWorkstation, at: Position(x: 1, y: 2))
        XCTAssert(workstation.isIdle)
        
        workstation.state = .busy
        XCTAssert(!(workstation.isIdle))
    }

}
