//
//  Simulator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class Simulator {
    
    let settings = SimulationSettings.shared
    
    static var shared = Simulator()
    private init() { }
    
    func startSimulation() {
//        var factoryLayout = createEmptyFactoryGrid()
//        let products = settings.products
//        ...
    }
    
}

// MARK: Simulation Steps
extension Simulator {
    
    fileprivate func createEmptyFactoryGrid() -> FactoryLayout {
        let grid = FactoryLayout(width: settings.factoryWidth, length: settings.factoryLength)
        debugPrint(infoMessage: "Factory Layout created: \(grid.width) x \(grid.length)")
        return grid
    }
    
}

// MARK: Debugging
extension Simulator {
    
    fileprivate func debugPrint(infoMessage message: String) {
        print(message)
    }
    
}
