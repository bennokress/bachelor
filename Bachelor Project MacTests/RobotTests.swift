//
//  RobotTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class RobotTests: XCTestCase {
    
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
    
    func testPositionDefaultInitialization() {
        let robot = standard.robot
        XCTAssert(robot.position == standard.factoryLayout.entrancePosition)
        XCTAssert(robot.state == .starting)
    }

}
