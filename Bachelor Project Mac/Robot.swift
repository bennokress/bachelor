//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Robot: CustomPrintable {
    
    let product: Product
    var position: Position
    var remainingRoute: [Position]
    var state: RobotState
    
    let routing = Routing()
    
    init(product: Product, in factoryLayout: FactoryLayout) {
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
    
    /// Robots are considered equal, if their position and the product they produce are equal
    static func == (lhs: Robot, rhs: Robot) -> Bool {
        return (lhs.product == rhs.product) && (lhs.position == rhs.position)
    }
    
}

extension Robot: CustomStringConvertible {
    
    var description: String {
        return "Robot (\(state.rawValue)) at \(position) with Product Type \(product.type.rawValue) - Remaining stations: \(remainingRoute.count)"
    }
    
}
