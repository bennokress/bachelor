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
    
    func testPositionDefaultInitialization() {
        
        // MARK: 🌦 Given
        let robot = standard.robot
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(robot.position == standard.factoryLayout.entrancePosition)
        XCTAssert(robot.state == .starting)
        
    }

}
