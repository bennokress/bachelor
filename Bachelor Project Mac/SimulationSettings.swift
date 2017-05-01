//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

struct SimulationSettings {
    
    // MARK: Quantities
    let generationSize = 10
    
    // MARK: Factory Layout
    let factoryWidth = 10
    let factoryLength = 10
    
    var entrance: Position {
        return Position(x: 2, y: 0)
    }
    
    var exit: Position {
        let thirdLastFieldNumber = factoryWidth * factoryLength - 3
        guard let exitPosition = Position(fromFieldnumber: thirdLastFieldNumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength) else {
            fatalError("Exit is outside of Factory Layout!")
        }
        return exitPosition
    }
    
    // MARK: Products
    let productAmount: [ProductType : Int] = [
        .pA: 1,
        .pB: 0,
        .pC: 0,
        .pD: 0,
        .pE: 0,
        .pF: 0
    ]
    
    // MARK: Workstations
    let workstationAmount: [WorkstationType : Int] = [
        .wsA: 1,
        .wsB: 1,
        .wsC: 1,
        .wsD: 1,
        .wsE: 1,
        .wsF: 1
    ]
    
}

// MARK: Initial Generation Calculation
extension SimulationSettings {

    func getInitialGeneration() -> [Factory] {
        
        // 1 - create empty factory layout
        var factoryLayout = createEmptyFactoryGrid()
        
        // 2 - generate products
        var products: [Product] = []
        for (productType, n) in productAmount {
            n.times { products.append(Product(type: productType)) }
        }
        
        // 3 - generate robots with each one owning a product and place it at the entrance
        for product in products {
            var robot = Robot(product: product)
            factoryLayout.addRobot(&robot)
        }
        
        // loop - for each needed individual (factory layout)
        var initialGeneration: [Factory] = []
        generationSize.times {
            // FIXME: Finish this loop implementation
            // 5 - generate workstations with positions in factory
            // 6 - update factory layout from step 4 with the generated workstations
            // 7 - generate factory
            // 8 - append factory to initial generation
            initialGeneration.append(Factory())
        }
        
        return initialGeneration
        
    }
    
}

// MARK: Simulation Steps
extension SimulationSettings {
    
    fileprivate func createEmptyFactoryGrid() -> FactoryLayout {
        let grid = FactoryLayout(width: factoryWidth, length: factoryLength)
        debugPrint(infoMessage: "Factory Layout created: \(grid.width) x \(grid.length)")
        return grid
    }
    
}

// MARK: Debugging
extension SimulationSettings {
    
    fileprivate func debugPrint(infoMessage message: String) {
        print(message)
    }
    
}
