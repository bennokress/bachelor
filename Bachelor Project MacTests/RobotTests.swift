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
    
    // MARK: Standard implementations to start with in each test, if needed
    
    var standardPosition1: Position {
        return Position(x: 3, y: 2)
    }
    
    var standardPosition2: Position {
        return Position(x: 6, y: 2)
    }
    
    var standardField1: Field {
        return Field(at: standardPosition1)
    }
    
    var standardField2: Field {
        return Field(at: standardPosition2)
    }
    
    var standardEmptyFactoryLayout: FactoryLayout {
        let entrance = Position(x: 2, y: 0)
        let exit = Position(x: 7, y: 4)
        return FactoryLayout(width: 10, length: 5, entrance: entrance, exit: exit)
    }
    
    var standardFactoryLayout: FactoryLayout {
        var factoryLayout = standardEmptyFactoryLayout
        factoryLayout.addWorkstation(standardWorkstation)
        return factoryLayout
    }
    
    var standardProduct: Product {
        return Product(type: .testProduct)
    }
    
    var standardWorkstation: Workstation {
        return Workstation(type: .testWorkstation, at: standardPosition2)
    }
    
    var standardRobot: Robot {
        return Robot(product: standardProduct, in: standardFactoryLayout)
    }
    
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
        let robot = standardRobot
        XCTAssert(robot.position == standardFactoryLayout.entrancePosition)
        XCTAssert(robot.state == .starting)
    }

}
