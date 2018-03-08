//
//  RoutingTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 30.04.17.
//  Copyright © 2017 Benno Kress. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class RoutingTests: XCTestCase {
    
    let standard = StandardImplementation()
    
    func testRobotOfProductWithNoWorkstationsGetsRouteDirectlyToExit() {
        
        // MARK: 🌦 Given
        let factoryLayout = standard.emptyFactoryLayout
        
        // MARK: 🌬 When
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        let robot = Robot(id: 0, product: Product(type: .emptyProduct), in: factoryLayout)
        
        // MARK: ☀️ Then
        XCTAssert(robot.remainingRoute == [exit])
        
    }
    
    func testRobotGetsCorrectRoute() {
        
        // MARK: 🌦 Given
        var factoryLayout = standard.emptyFactoryLayout
        let testWorkstation = standard.workstation
        
        // MARK: 🌬 When
        factoryLayout.addWorkstation(testWorkstation)
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        let robot = Robot(id: 0, product: Product(type: .testProduct), in: factoryLayout)
        
        // MARK: ☀️ Then
        XCTAssert(robot.remainingRoute == [factoryLayout.workstations.first!.position, exit])
        
    }
    
    func testShortestRouteIsChosen() {
        
        // MARK: 🌦 Given
        var factoryLayout = standard.emptyFactoryLayout
        let nearWorkstation = Workstation(id: 1, type: .testWorkstation, at: standard.position1)
        let farWorkstation = standard.workstation
        
        // MARK: 🌬 When
        factoryLayout.addWorkstation(nearWorkstation)
        factoryLayout.addWorkstation(farWorkstation)
        guard let exit = factoryLayout.exitPosition else {
            fatalError("No exit found in factory layout!")
        }
        let robot = Robot(id: 0, product: Product(type: .testProduct), in: factoryLayout)
        
        // MARK: ☀️ Then
        XCTAssert(robot.remainingRoute == [nearWorkstation.position, exit])
        
    }
    
}
