//
//  WorkstationTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class WorkstationTests: XCTestCase {
    
    let standard = StandardImplementation()
    
    func testWorkstationKnowsIfIdle() {
        
        // MARK: 🌦 Given
        var workstation = standard.workstation
        
        // MARK: 🌬 When
        workstation.work(on: standard.robot)
        
        // MARK: ☀️ Then
        XCTAssert(!(workstation.isIdle))
        
        // MARK: 🌬 When
        workstation.finishWorking()
        
        // MARK: ☀️ Then
        XCTAssert(workstation.isIdle)
        
    }
    
    func testWorkstationStartsIdle() {
        
        // MARK: 🌦 Given
        let workstation = standard.workstation
        
        // MARK: 🌬 When
        // No action taken
        
        // MARK: ☀️ Then
        XCTAssert(workstation.isIdle)
        
    }

}
