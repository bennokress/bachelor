//
//  Robot.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 27.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct Robot: Identifiable, CustomPrintable {
    
    let id: Int
    let product: Product
    var position: Position
    var remainingRoute: [Position]
    var state: RobotState
    
    let routing = Routing()
    
    init(id: Int, product: Product, in factoryLayout: FactoryLayout) {
        guard let entrance = factoryLayout.entrancePosition else { fatalError("No entrance found in factory layout!") }
        
        self.id = id
        self.product = product
        self.state = .starting
        self.position = entrance
        self.remainingRoute = routing.getShortestRoute(containing: product.neededWorkstations, in: factoryLayout)
    }
    
    mutating func performStep(in factoryLayout: FactoryLayout) -> Robot {
        let potentialTargetFields = factoryLayout.potentialTargetFields(around: self.position)
        print(potentialTargetFields)
        // check current state
        return self
    }
    
}

extension Robot: CustomStringConvertible {
    
    var description: String {
        return "Robot #\(id) (\(state)) at \(position) with Product Type \(product.type.rawValue) - Remaining stations: \(remainingRoute.count)"
    }
    
}
