//
//  SimulationSettings.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class SimulationSettings {
    
    static var shared = SimulationSettings()
    private init() { }
    
    // MARK: Quantities
    var generationSize = 10
    
    // MARK: Factory Layout
    var factoryWidth = 10
    var factoryLength = 10
    var entrance: Position { return Position(x: 2, y: 0) }
    var exit: Position {
        let thirdLastFieldNumber = factoryWidth * factoryLength - 3
        return Position(fromFieldnumber: thirdLastFieldNumber, withFactoryWidth: factoryWidth, andFactoryLength: factoryLength)!
    }
    
    // MARK: Products
    var products = [
        Product(),
        Product()
    ]
    
}

// MARK: Initial Generation Calculation
extension SimulationSettings {

    func getInitialGeneration() -> [Factory] {
        
        // 1 - create empty factory layout
        // for each factory
            // 2 - generate workstations with positions in factory
            // 3 - update factory layout from step 1 with the generated workstations
            // 4 - generate products
            // 5 - generate robots with each one owning a product
            // 6 - place robots at the entrance of the factory layout
            // 7 - generate factory
            // 8 - append factory to initial generation
        
        let initialGeneration: [Factory] = []
        
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
