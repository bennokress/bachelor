//
//  SimulationSettingsTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class SimulationSettingsTests: XCTestCase {
    
    let settings = SimulationSettings.shared

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExitIsAtThirdLastFieldInFactoryLayout() {
        
        settings.factoryWidth = 5
        settings.factoryLength = 10
        
        dump(settings.exit)
        
        XCTAssert(settings.exit == Position(x: 2, y: 9), "Exit should be at third last field in the factory layout unless changed in SimulationSettings.")
    }

}