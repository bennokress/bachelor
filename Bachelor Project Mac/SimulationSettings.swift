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
    var products = [
        Product(type: .pA),
        Product(type: .pB)
    ]
    
}

// MARK: Initial Generation Calculation
extension SimulationSettings {

    func getInitialGeneration() -> [Factory] {
        
        var initialGeneration: [Factory] = []
        
        // 1 - create empty factory layout
        // 2 - generate products
        // 3 - generate robots with each one owning a product
        // 4 - place robots at the entrance of the factory layout
        // for each needed individual (factory layout)
            // 5 - generate workstations with positions in factory
            // 6 - update factory layout from step 4 with the generated workstations
            // 7 - generate factory
            // 8 - append factory to initial generation
        
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
