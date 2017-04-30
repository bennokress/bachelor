//
//  RobotTests.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import XCTest
@testable import Bachelor_Project_Mac

class RobotTests: XCTestCase {
    
    var getTestProduct: Product {
        return Product(type: .testProduct)
    }
    
    var getTestFactoryLayout: FactoryLayout {
        let factoryWidth = 5
        let factoryLength = 4
        let entrancePosition = Position(fromFieldnumber: 2, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
        let exitPosition = Position(fromFieldnumber: 17, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
        return FactoryLayout(width: factoryWidth, length: factoryLength, entrance: entrancePosition, exit: exitPosition)
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPositionDefaultInitialization() {
        let testFactoryLayout = getTestFactoryLayout
        let testProduct = getTestProduct
        let testRobot = Robot(product: testProduct, in: testFactoryLayout)
        XCTAssert(testRobot.position == testFactoryLayout.entrancePosition)
        XCTAssert(testRobot.state == .starting)
    }
    
    func testRobotRouteIncludesTestWorkstationAndExit() {
//        var testFactoryLayout = getTestFactoryLayout
//        let testProduct = getTestProduct
//        
//        guard let exitPosition = testFactoryLayout.exitPosition else { return XCTFail("No exit found in factory layout!") }
//        
//        let workstationPosition = Position(fromFieldnumber: 9, in: testFactoryLayout)!
//        let testWorkstation = Workstation(type: .testWorkstation, at: workstationPosition)
//        testFactoryLayout.addWorkstation(testWorkstation)
//        
//        let testRobot = Robot(product: testProduct, in: testFactoryLayout)
//        
//        XCTAssert(testRobot.remainingRoute == [testWorkstation.position, exitPosition])
    }

}
