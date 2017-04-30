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
    
    init(product: Product, in factoryLayout: FactoryLayout) {
        guard let entrance = factoryLayout.entrancePosition else {
            fatalError("No entrance found in factory layout!")
        }
        guard let routeForProduct = routing.getShortestRoute(containing: product.neededWorkstations, in: factoryLayout) else {
            fatalError("Factory layout does not contain all needed stations for the product!")
        }
        
        self.product = product
        self.state = .starting
        self.position = entrance
        self.remainingRoute = routeForProduct
    }
    
}

extension Robot: Equatable {
    
    static func == (lhs: Robot, rhs: Robot) -> Bool {
        return (lhs.product == rhs.product) && (lhs.position == rhs.position)
    }
    
}
