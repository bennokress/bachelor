//
//  Coordinator.swift
//  Bachelor Project Mac
//
//  Created by Benno Kress on 29.04.17.
//  Copyright © 2017 it-economics. All rights reserved.
//

import Foundation

class Coordinator {
    
    let settings = SimulationSettings.shared
    
    static var shared = Coordinator()
    private init() { }
    
    func startSimulation() {
//        var factoryLayout = createEmptyFactoryGrid()
//        let products = settings.products
//        ...
    }
    
}

// MARK: Simulation Steps
extension Coordinator {
    
    fileprivate func createEmptyFactoryGrid() -> FactoryLayout {
        let grid = FactoryLayout(width: settings.factoryWidth, length: settings.factoryLength)
        debugPrint(infoMessage: "Factory Layout created: \(grid.width) x \(grid.length)")
        return grid
    }
    
}

// MARK: Debugging
extension Coordinator {
    
    fileprivate func debugPrint(infoMessage message: String) {
        print(message)
    }
    
}
