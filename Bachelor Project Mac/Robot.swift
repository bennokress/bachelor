//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Robot {
    
    let product: Product
    var position: Position
    var remainingRoute: [Position]
    var state: RobotState
    
    let routing = Routing.shared
    
    init(product: Product, in factoryLayout: FactoryLayout = FactoryLayout()) {
        guard let entrance = factoryLayout.entrancePosition else { fatalError("No entrance found in factory layout!") }
        
        self.product = product
        self.state = .starting
        self.position = entrance
        self.remainingRoute = routing.getShortestRoute(containing: product.neededWorkstations, in: factoryLayout)
    }
    
    mutating func move(to newPosition: Position) {
        position = newPosition
    }
    
}

extension Robot: Equatable {
    
    static func == (lhs: Robot, rhs: Robot) -> Bool {
        return (lhs.product == rhs.product) && (lhs.position == rhs.position)
    }
    
}
