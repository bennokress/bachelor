//
//  RoutingTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class RoutingTests: XCTestCase {
    
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
    
    func testRobotOfProductWithNoWorkstationsGetsRouteDirectlyToExit() {
        let factoryLayout = standard.emptyFactoryLayout
        
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        
        let robot = Robot(id: 0, product: Product(type: .emptyProduct), in: factoryLayout)
        XCTAssert(robot.remainingRoute == [exit])
    }
    
    func testRobotGetsCorrectRoute() {
        var factoryLayout = standard.emptyFactoryLayout
        let testWorkstation = standard.workstation
        factoryLayout.addWorkstation(testWorkstation)
        
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        
        let robot = Robot(id: 0, product: Product(type: .testProduct), in: factoryLayout)
        XCTAssert(robot.remainingRoute == [factoryLayout.workstations[0].position, exit])
    }
    
    func testShortestRouteIsChosen() {
        var factoryLayout = standard.emptyFactoryLayout
        let nearWorkstation = Workstation(type: .testWorkstation, at: standard.position1)
        factoryLayout.addWorkstation(nearWorkstation)
        let farWorkstation = standard.workstation
        factoryLayout.addWorkstation(farWorkstation)
        
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        
        let robot = Robot(id: 0, product: Product(type: .testProduct), in: factoryLayout)
        XCTAssert(robot.remainingRoute == [nearWorkstation.position, exit])
    }
    
}
